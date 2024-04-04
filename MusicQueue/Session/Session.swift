class Session {
    @Injected private var logger: CustomLogger
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    private var _queue: SongQueue<AnyMusicItem> = SongQueue()
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
    }
    
    var queue: SongQueue<AnyMusicItem> {
        get { return _queue }
        set { _queue = newValue }
    }
    
    var users: [User] {
        get { return _users }
        set { _users = newValue }
    }
    
    var socketEventSender: SocketEventSender {
        get { return _socketEventSender }
    }
    
    func join(hostName: String, completion: @escaping (Result<JoinSessionResponse, Error>) -> Void) {
        socketEventSender.joinSession(sessionId: self.sessionId, hostName: hostName, completion: completion)
    }
    
    func addSong(song: AnyMusicItem, completion: @escaping (Result<Bool, Error>) -> Void) {
        _socketEventSender.addSong(sessionId: self.sessionId, songItem: song, completion: completion)
    }
    
    func removeSong(songId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        _socketEventSender.removeSong(sessionId: sessionId, songID: songId, completion: completion)
    }
    
    func getQueuedSongs() -> [AnyMusicItem] {
        return _queue.getQueueItems()
    }
    
    func contains(songId: String) -> Bool {
        return _queue.contains(songId: songId)
    }
}

extension Session {
    
    private func subscribeToSessionEvents() {
        notificationCenter.addObserver(self, selector: #selector(songAddedHandler(_:)), name: .songAddedNotification, object: SocketEventReceiver.self)
    }
    
    private func userJoinedHanlder() {
    }
    
    @objc private func songAddedHandler(_ notificaiton: Notification) {
        guard let song = notificaiton.object as? AnyMusicItem else {
            logger.error("Could not extract song from the notificaiton")
            return
        }
        
        _queue.enqueue(newElement:  song)
    }
}

