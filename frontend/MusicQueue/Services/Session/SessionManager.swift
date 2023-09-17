import Foundation
import SocketIO
import SwiftUI

class SessionManager: ObservableObject {
    
    // MARK: - State
    @Published var isActive: Bool = false
    
    private var socketConnectionHandler: SocketConnectionHandler
    private var socketEventSender: SocketEventSender
    private var _isHost: Bool
    
    // MARK: - Session data
    private var sessionId: String
    private var queue: Array<GenericSong> = []
    
    //MARK: - Session data
    init(socketConnectionHandler: SocketConnectionHandler) { self.socketConnectionHandler = socketConnectionHandler
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
        
        // subscribe session to socket events
        let subscription = socketConnectionHandler.eventPublisher
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
    
    func isHost() -> Bool {
        return self._isHost
    }
    
    func getQueueItems() -> Array<GenericSong> {
        return self.queue
    }
}
