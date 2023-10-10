import Foundation
import SocketIO
import SwiftUI
import Combine

class SessionManager: ObservableObject {
    
    // MARK: - State
    @Published var isConnected: Bool = false
    
    private var socketConnectionHandler: SocketConnectionHandler
    private var socketEventSender: SocketEventSender
    private var _isHost: Bool = false
    
    // MARK: - Session data
    private var _hostId: String?
    private var _sessionId: String?
    private var _sessionName: String?
    private var _hostName: String?
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
    
    //MARK: - Session data
    init() {
        self.socketConnectionHandler = SocketConnectionHandler()
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
        // Subscribe to the connection changes
        socketConnectionHandler.$connected
            .sink { connected in
                self.isConnected = connected
            }
            .store(in: &cancellables)
        
        // subscribe session to socket events
        socketConnectionHandler.eventPublisher
            .sink { [weak self] event, items in
                print("ITEMS", items)
                self?.handleEvent(event: event, items: items)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        socketConnectionHandler.disconnect()
    }
    
    // MARK: - Socket.IO messages
    func handleEvent(event: String, items: [Any]) {
        switch event {
        case "sessionCreated":
            self._isHost = true
            print("SESSION DATA", items)
            if let sessionData = items.first as? [String: [String: Any]] {
                if let response = sessionData["sessionCreatedResponse"] {
                    self._hostId = response["hostId"] as? String
                    self._sessionId = response["sessionId"] as? String
                    self._sessionName = response["sessionName"] as? String
                } else {
                    // Handle error
                }
            }
            
        case "sessionJoined":
            // load data from items into session
            print("join")
            self.isConnected = true
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
    
    func joinSession(sessionId: String) throws {
        try self.socketEventSender.joinSession(sessionID: sessionId)
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
}
