import Foundation
import SocketIO
import SwiftUI

class SessionManager: ObservableObject {
    
    // MARK: - State
    @Published var isActive: Bool = false
    
    private var socketConnectionHandler: SocketConnectionHandler
    private var socketEventSender: SocketEventSender
    private var _isHost: Bool = false
    
    // MARK: - Session data
    private var sessionId: String = "-1"
    private var queue: Array<GenericSong> = []
    
    //MARK: - Session data
    init(socketConnectionHandler: SocketConnectionHandler) {
        self.socketConnectionHandler = socketConnectionHandler
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
        
        // subscribe session to socket events
        _ = socketConnectionHandler.eventPublisher
            .sink { event, items in
                self.handleEvent(event: event, items: items)
            }
    }
    
    
    
    // MARK: - Socket.IO messages
    func handleEvent(event: String, items: [Any]) {
        switch event {
        case "sessionCreated":
            print("created")
            self.isActive = true
        case "sessionJoined":
            // load data from items into session
            print("join")
            self.isActive = true
        case "sessionLeft":
            self.isActive = false
        case "songVoted":
            print("Song voted")
            voteSong(songId: items[0] as! Int, vote: items[1] as! Int)
            
        default:
            print("Unhandled event: \(event)")
        }
    }
    
    func createSession() {
        self.socketEventSender.createSession()
    }
    
    func joinSession(sessionId: String) {
        self.socketEventSender.joinSession(sessionID: sessionId)
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
        return self.queue
    }
}
