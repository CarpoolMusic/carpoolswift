import Foundation
import SocketIO

class SessionManager {
    // MARK: - State
    
    var sessionID: Int
    var onQueueUpdate: (([Song]) -> Void)?
    private var users: [User]
    private var sessionAdmin: User?
    
    let manager = SocketManager(socketURL: URL(string: "https://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient?

    init() {
        self.sessionID = 0
        self.users = []
        self.sessionAdmin = nil
        self.socket = manager.defaultSocket
        
        self.configureSocketEvents()
    }
    
    // MARK: - Socket.IO events
    
    private func configureSocketEvents() {
        socket?.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
        
        socket?.on("session created") { data, _ in
            guard let sessionID = data[0] as? String else { return }
            // Do something with the sessionID
        }
        
        socket?.on("session joined") { data, _ in
                guard let sessionID = data[0] as? String else { return }
                // Do something when session is joined
            }

        socket?.on("left session") { data, _ in
            guard let sessionID = data[0] as? String else { return }
            // Do something when left session
        }

        socket?.on("session deleted") { data, _ in
            guard let sessionID = data[0] as? String else { return }
            // Do something when session is deleted
        }

        socket?.on("queue updated") { data, _ in
            guard let queue = data[0] as? [[String: Any]] else { return }
            // Convert data to Song objects and call the closure
            let updatedQueue = queue.map { Song(dictionary: $0) }
            self.onQueueUpdate?(updatedQueue)
        }

        socket?.on("error") { data, _ in
            guard let errorMessage = data[0] as? String else { return }
            // Handle error message
        }
        
        // Similarly, handle other events from the server
    }
    
    // MARK: - Socket.IO messages
    
    func createSession() {
        socket?.emit("create session")
    }

    func joinSession(sessionID: String) {
        socket?.emit("join session", sessionID)
    }

    func leaveSession(sessionID: String) {
        socket?.emit("leave session", sessionID)
    }

    func addSongToQueue(sessionId: String, songData: [String: Any]) {
        socket?.emit("add song", ["sessionId": sessionId, "songData": songData] as [String : Any])
    }

    func removeSongFromQueue(sessionId: String, songID: String) {
        socket?.emit("remove song", ["sessionId": sessionId, "songID": songID])
    }
    
    func voteSong(sessionId: String, songID: String, vote: Int) {
        socket?.emit("vote song", ["sessionId": sessionId, "songID": songID, "vote": vote] as [String : Any])
    }
    
    // MARK: - Connection methods
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
}
