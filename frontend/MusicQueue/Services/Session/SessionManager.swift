import Foundation
import SocketIO
import SwiftUI

class SessionManager: ObservableObject, SessionManagerProtocol {
    
    // MARK: - State
    
    private let socketService: SocketServiceProtocol
    
    @Published var connected: Bool?
    @Published var activeSession: Session?
    @Published var queueUpdated: Bool = false
    
    @Published var currentSong: CustomSong?
    var lastSong: CustomSong?
    
    init(socketService: SocketServiceProtocol) {
        self.socketService = socketService
        self.socketService.delegate = self
    }
    
    
    
    // MARK: - Socket.IO messages
    func handleEvent(_ event: SocketEvent) {
        switch event {
        case .connected:
            // Set the connected flag to true for the Session Manager
            self.connected = true
        case .disconnected:
            // Set the connected flag to false for the Session Manager
            self.connected = false
        case .sessionCreated(let sessionId):
            // Set the intial values of the session and then load
            self.activeSession = Session(id: sessionId, hostId: self.socketService.getSocketId())
        case .sessionJoined(let sessionId):
            // Do something when a session is joined.
            print()
        case .leftSession(let sessionId):
            // Do something when a session is left.
            // Continue for other cases...
            print()
        case .memberLeft(let memberId):
            // Do something when a member of the session leaves
            print()
        case .queueUpdated(let queue):
            // DO something when the queue is updated
            var newQueue: [CustomSong] = []
            for songDict in queue {
                if let song = CustomSong(dictionary: songDict) {
                    newQueue.append(song)
                }
            }
            // Update the queue
            self.activeSession?.queue = newQueue
            self.queueUpdated.toggle()
        default:
            print("Unhandled event: \(event)")
        }
    }
}

    

// MARK: - Socket Service Delegate methods (Recieve from server events)
extension SessionManager: SocketServiceDelegate {
    
    func socketDidConnect() {
        print("Client connected")
    }
    
    func socketDidDisconnect(with error: Error?) {
        print("Client disconnected")
    }
    
}
