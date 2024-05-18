import SwiftUI

class Session: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    @Published private(set) var queue: SongQueue = SongQueue()
    
    private var _users: [User] = []
    private var _socketEventSender: SocketEventSender
    
    public private(set) var isHost: Bool = true
    public private(set) var hostName: String
    public private(set) var sessionId: String
    public private(set) var sessionName: String
    
    init(sessionId: String, sessionName: String, hostName: String) {
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.hostName = hostName
        self._socketEventSender = SocketEventSender(socket: Socket())
        
        subscribeToSessionEvents()
    }
    
    var users: [User] {
        get { return _users }
        set { _users = newValue }
    }
    
    func connect() async throws {
        try await _socketEventSender.connect()
    }
    
    func isConnected() -> Bool {
        return _socketEventSender.isConnected()
    }
    
    func join(hostName: String) async throws -> [String: Any] {
        return try await _socketEventSender.joinSession(sessionId: self.sessionId, hostName: hostName)
    }
    
    func addSong(song: SongProtocol) async throws -> [String: Any] {
        return try await _socketEventSender.addSong(sessionId: self.sessionId, song: song)
    }
    
    func removeSong(songId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        _socketEventSender.removeSong(sessionId: sessionId, songID: songId, completion: completion)
    }
    
    func contains(songId: String) -> Bool {
        return queue.contains(songId: songId)
    }
}

extension Session {
    
    private func subscribeToSessionEvents() {
        notificationCenter.addObserver(self, selector: #selector(songAddedHandler(_:)), name: .songAddedNotification, object: nil)
    }
    
    @objc private func songAddedHandler(_ notificaiton: Notification) {
        guard let song = notificaiton.object as? SongProtocol else {
            logger.error("Could not extract song from the notificaiton")
            return
        }
        
        queue.enqueue(newSong: song)
    }
}

