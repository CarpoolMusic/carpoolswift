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
    
    
    // MARK: - Session methods
    
    func isHost() -> Bool {
        return self.activeSession?.hostId == self.socketService.getSocketId()
    }
    
    func getNextSong() -> CustomSong? {
        if let nextSong = activeSession?.queue.first {
            self.lastSong = currentSong
            self.currentSong = nextSong
            // remove the song from the queue
            self.removeSongFromQueue(sessionId: self.activeSession?.id ?? "", songID: nextSong.id.rawValue)
        }
        print("NEXT SONG: \(String(describing: self.currentSong))")
        return currentSong
    }
    
    func getLastSong() {
        
    }
    
    
    // MARK: - Send to server methods
    func handleError(_ error: SocketError) {
        // Emit error event to the server
        socketService.emit(event: "error", with: ["error": error.localizedDescription])
    }
    
    func connect() {
        socketService.connect()
    }
    
    func disconnect() {
        socketService.disconnect()
    }
    
    func createSession() {
        socketService.emit(event: "create session", with: [:])
    }
    
    func joinSession(sessionID: String) {
        socketService.emit(event: "join session", with: [sessionID: "sessionID"])
    }
    
    func leaveSession(sessionID: String) {
        socketService.emit(event: "leave session", with: [sessionID: "sessionID"])
    }
    
    func addSongToQueue(sessionId: String, song: CustomSong) {
        socketService.emit(event: "add song", with: ["sessionId": sessionId, "songData": song.toDictionary()] as [String : Any])
    }
    
    func removeSongFromQueue(sessionId: String, songID: String) {
        socketService.emit(event: "remove song", with: ["sessionId": sessionId, "songID": songID])
    }
    
    func voteSong(sessionId: String, songID: String, vote: Int) {
        socketService.emit(event: "vote song", with: ["sessionId": sessionId, "songID": songID, "vote": vote] as [String : Any])
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
    
    func socketDidReceiveEvent(event: String, with items: [Any]) {
        switch event {
        case "connected":
            handleEvent(.connected)
        case "disconnected":
            handleEvent(.disconnected)
        case "session created":
            guard let sessionId = items.first as? String else { return }
            handleEvent(.sessionCreated(sessionId))
        case "session joined":
            guard let sessionId = items.first as? String else { return }
            handleEvent(.sessionJoined(sessionId))
        case "left session":
            guard let sessionId = items.first as? String else { return }
            handleEvent(.leftSession(sessionId))
        case "session deleted":
            // Handle this based on the type of the item (String or Dictionary) received in items
            guard let sessionId = items.first as? String else { return }
            handleEvent(.sessionJoined(sessionId))
        case "member left":
            guard let userId = items.first as? String else { return }
            handleEvent(.memberLeft(userId))
        case "queue updated":
            guard let queue = items.first as? [[String: Any]] else { return }
            handleEvent(.queueUpdated(queue))
        case "error":
            guard let error = items.first as? String else { return }
            handleError(.genericError(error))
        case "permissions error":
            guard let error = items.first as? String else { return }
            handleError(.permissionsError(error))
        default:
            print("Unhandled event received: \(event)")
        }
    }
}
