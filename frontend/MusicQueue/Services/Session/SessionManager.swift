import Foundation
import SocketIO
import SwiftUI
import Combine
import MusicKit

class SessionManager: ObservableObject {
    
    // MARK: - State
    @Published var isConnected: Bool = false
    @Published var isActive: Bool = false
    
    // Set each time a song is added to the queue
    @Published var songAdded: Bool = false
    @Published var queueUpdated: Bool = false
    
    private var searchManager: SearchManager
    private var socketConnectionHandler: SocketConnectionHandler
    private var socketEventSender: SocketEventSender
    private var _isHost: Bool = false
    private var _queue: Queue = Queue()
    
    // MARK: - Session data
    private var _hostId: String?
    private var _sessionId: String?
    private var _sessionName: String?
    private var _hostName: String?
    private var _users: [String]?
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Session data
    init() {
        print("Session Manager init")
        self.socketConnectionHandler = SocketConnectionHandler()
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
//        self.searchManager = (UserDefaults.standard.string(forKey: "musicServiceType") == "apple") ? SearchManager(AppleMusicSearchManager()) : SearchManager(SpotifySearchManager())
        self.searchManager = SearchManager(AppleMusicSearchManager())
        
        // Subscribe to the connection changes
        socketConnectionHandler.$connected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.isConnected = connected
            }
            .store(in: &cancellables)
        
        // subscribe session to socket events
        socketConnectionHandler.eventPublisher
            .sink { [weak self] event, items in
                self?.handleEvent(event: event, items: items)
            }
            .store(in: &cancellables)
        
        // subscribe to changes i
        _queue.$updated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.queueUpdated.toggle()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        socketConnectionHandler.disconnect()
    }
    
    
    // Accessors
    var hostId: String {
        get {
            return _hostId ?? ""
        }
    }
    
    var sessionId: String {
        get {
            return _sessionId ?? ""
        }
        set {
            _sessionId = newValue
        }
    }
    
    var sessionName: String {
        get {
            return _sessionName ?? ""
        }
    }
    
    var hostName: String {
        get {
            return _hostName ?? ""
        }
    }
    
    var users: [String] {
        get {
            return _users ?? []
        }
        set{
            _users = newValue
        }
    }
    
    var queue: Queue {
        get {
            return _queue
        }
    }
    
    // MARK: - Socket.IO messages
    func handleEvent(event: String, items: [Any]) {
        print("EVENT ", event)
        switch event {
        case "sessionCreated":
            print("Session created")
            handleCreateSessionResponse(items: items)
        case "sessionJoined":
            print("Session joined")
            handleJoinSessionResponse(items: items)
        case "songAdded":
            print("Song Added")
            handleSongAddedEvent(items: items)
        case "songVoted":
            print("Song voted")
            handleSongVotedEvent(items: items)
//        case "userJoined":
//            handleUserJoinedEvent(items: items)
//        case "sessionLeft":
//            self.isConnected = false
            
        default:
            print("Unhandled event: \(event)")
        }
    }
    
    func connect() {
        self.socketConnectionHandler.connect()
    }
    
    func disconnect() {
        self.socketConnectionHandler.disconnect()
    }
    
    func createSession(hostName: String, sessionName: String) throws {
        try self.socketEventSender.createSession(hostName: hostName, sessionName: sessionName)
    }
    
    func joinSession(sessionId: String, hostName: String) throws {
        try self.socketEventSender.joinSession(sessionId: sessionId, hostName: hostName)
    }
    
    func leaveSession() {
        self.socketEventSender.leaveSession(sessionId: self.sessionId)
    }
    
    func addSong(song: AnyMusicItem) throws {
        try self.socketEventSender.addSong(sessionId: self.sessionId, song: song)
    }
    
    func voteSong(songId: String, vote: Int) throws {
        try self.socketEventSender.voteSong(sessionId: self.sessionId, songId: songId, vote: vote)
        
    }
    
    func getQueuedSongs() -> Array<AnyMusicItem> {
        return _queue.getQueueItems()
    }
    
    func isHost() -> Bool {
        return self._isHost
    }
    
    // MARK: - Search methods
    
    func searchSongs(query: String, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        self.searchManager.searchSongs(query: query, completion: completion)
    }
    
    //MARK: - Event Handling
    
    func handleCreateSessionResponse(items: [Any]) {
        if let firstItem = items.first as? [String: Any] {
            if let sessionId = firstItem["sessionId"] as? String {
                self._sessionId = sessionId
                self.isActive = true
            } else if let errResponse = firstItem["error"] {
                print("Handle err", errResponse)
            } else {
                print("Unknown response")
            }
        }
    }
    
    func handleJoinSessionResponse(items: [Any]) {
        if let firstItem = items.first as? [String: Any] {
            if let users = firstItem["users"] as? [String] {
                self.users = users
                self.isActive = true
            } else if let errResponse = firstItem["error"] {
                print("Handle err", errResponse)
            } else {
                print("Unkown response")
            }
        }
    }
    
    // Recieved when a some other user joins this session
    func handleUserJoinedEvent(items: [Any]) {
        if let firstItem = items.first as? [String: Any] {
            if let user = firstItem["user"] as? String {
                self.users.append(user)
            }
        } else {
            print("Unkown event in userJoined")
        }
    }
    
    // Recieved when a user in the session adds a song (including sender)
    func handleSongAddedEvent(items: [Any]) {
        
        if let songItems = items.first as? [String: Any] {
            guard let song: Song = buildMusicItem(songItems: songItems) else {
                print("Cannot parse song")
                return
            }
            
            // Resolve the song with music service
            searchManager.resolveSong(song: song) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let song):
                        self._queue.enqueue(song: song)
                        self.songAdded = true
                    case .failure(let error):
                        // Handle error
                        print("Error resolving song \(error)")
                    }
                }
            }
        } else {
            // handle error
            print("Error in response from songAddedEvent")
        }
    }
    
    func handleSongVotedEvent(items: [Any]) {
        
        if let voteItems = items.first as? [String : Any] {
            if let songId = voteItems["songId"] as? String, let vote = voteItems["vote"] as? Int {
                (vote == -1) ? self._queue.donwvote(songId: songId) : self._queue.upvote(songId: songId)
            }
        }
    }
  
    // MARK: - Helper method
    
    private func buildMusicItem(songItems: [String: Any]) -> Song? {
        if let song = songItems["song"] as? [String: Any] {
            let service = song["service"] as? String ?? ""
            let id = song["id"] as? String ?? ""
            let title = song["title"] as? String ?? ""
            let album = song["album"] as? String ?? ""
            let artist = song["artist"] as? String ?? ""
            let votes = song["votes"] as? Int ?? -1
            return Song(service: service, id: id, title: title, artist: album, album: artist, votes: votes)
        }
        
        return nil
    }
    

   
    
    
}
