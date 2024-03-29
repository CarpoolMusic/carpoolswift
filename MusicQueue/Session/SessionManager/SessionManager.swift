// MARK: - CodeAI Output
/**
 This class manages the session and connection with the server using SocketIO.
 It provides functionality to check if the user is connected, active, and if a song has been added or the queue has been updated.
 */

import Foundation
import SocketIO
import SwiftUI
import Combine
import MusicKit
import os

/**
 An error enum for SessionManager.
 */
enum SessionManagerError: Error {
    case InvalidSessionId
}

/**
 The SessionManager class is an ObservableObject that manages the session and connection with the server using SocketIO.
 */
class SessionManager: ObservableObject {
    @Injected private var apiManager: APIManagerProtocol
    
    private let logger = Logger()
    
    /// Indicates if the user is connected to the server.
    @Published var isConnected: Bool = false
    /// Indicates if the user's session is active.
    @Published var isActive: Bool = false
    
    private(set) var queue: SongQueue<AnyMusicItem> = SongQueue()
    private var users: [User] = []
    private var socketEventSender: SocketEventSender
    
    private(set) var isHost: Bool = true
    private var hostName: String
    
    private var sessionId: String
    private var sessionName: String
    
    init(sessionId: String, sessionName: String, hostName: String) {
        self.socketEventSender = SocketEventSender(socket: Socket())
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.hostName = hostName
    }
    
    deinit {
        self.socketEventSender.disconnect()
    }
    
    func connect() {
        self.socketEventSender.connect()
    }
    
    func createSession(hostId: String, sessionName: String) throws {
//        apiManager.createSessionRequest(hostId: hostName, socketId: <#T##String#>, sessionName: <#T##String#>, completion: <#T##(Result<CreateSessionResponse, Error>) -> Void#>)
}
    
    func joinSession(sessionId: String, hostName: String) throws {
        try self.socketEventSender.joinSession(sessionId: sessionId, hostName: hostName)
    }
    
    func addSong(song: AnyMusicItem) throws {
        try self.socketEventSender.addSong(sessionId: self.sessionId, songItem: song)
    }
    
    func removeSong(songId: String) throws {
        try self.socketEventSender.removeSong(sessionId: sessionId, songID: songId)
    }
    
   /**
     Returns an array of queued songs in the current session's queue.
     
     - Returns: An array of AnyMusicItem objects representing the queued songs.
     */
    func getQueuedSongs() -> [AnyMusicItem] {
        return queue.getQueueItems()
    }
}
