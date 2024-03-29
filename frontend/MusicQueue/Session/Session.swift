class Session {
    private var _queue: SongQueue<AnyMusicItem> = SongQueue()
    private var _users: [User] = []
    private var _socketEventSender: SocketEventSender
    
    public private(set) var isHost: Bool = true
    public private(set) var hostName: String
    public private(set) var sessionId: String
    public private(set) var sessionName: String
    
    init(sessionId: String, sessionName: String, hostName: String, socket: SocketEventSender) {
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.hostName = hostName
        self._socketEventSender = socket
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
    
    func addSong(song: AnyMusicItem) throws {
        try _socketEventSender.addSong(sessionId: self.sessionId, songItem: song)
    }
    
    func removeSong(songId: String) throws {
        try _socketEventSender.removeSong(sessionId: sessionId, songID: songId)
    }
    
    func getQueuedSongs() -> [AnyMusicItem] {
        return _queue.getQueueItems()
    }
}

