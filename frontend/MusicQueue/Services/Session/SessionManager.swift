import Foundation
import SocketIO
import SwiftUI
import Combine

class SessionManager: ObservableObject {
    
    // MARK: - State
    @Published var isConnected: Bool = false
    @Published var isActive: Bool = false
    
    private var socketConnectionHandler: SocketConnectionHandler
    private var socketEventSender: SocketEventSender
    private var _isHost: Bool = false
    
    // MARK: - Session data
    private var _hostId: String?
    private var _sessionId: String?
    private var _sessionName: String?
    private var _hostName: String?
    private var _users: [String]?
    private var _queue: Array<GenericSong> = []
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    //MARK: - Session data
    init() {
        self.socketConnectionHandler = SocketConnectionHandler()
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
        // Subscribe to the connection changes
        socketConnectionHandler.$connected
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
    }
    
    deinit {
        socketConnectionHandler.disconnect()
    }
    
    // MARK: - Socket.IO messages
    func handleEvent(event: String, items: [Any]) {
        print("EVENT ", event)
        switch event {
        case "sessionCreated":
            handleCreateSessionResponse(items: items)
        case "sessionJoined":
            handleJoinSessionResponse(items: items)
        case "userJoined":
            handleUserJoinedEvent(items: items)
        case "sessionLeft":
            self.isConnected = false
        case "songVoted":
            print("Song voted")
            voteSong(songId: items[0] as! Int, vote: items[1] as! Int)
            
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
        try self.socketEventSender.joinSession(sessionID: sessionId, hostName: hostName)
    }
    
    func leaveSession() {
        self.socketEventSender.leaveSession(sessionID: self.sessionId)
    }
    
    func voteSong(songId: Int, vote: Int) {
        
    }
    
    func isHost() -> Bool {
        return self._isHost
    }
    
    func getQueueItems() -> Array<GenericSong> {
        return self._queue
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
        print("SESSION JOINEDDJDJFDJF")
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

   
    
    
}
