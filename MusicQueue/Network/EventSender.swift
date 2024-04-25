//// MARK: - CodeAI Output
///**
// This extension adds additional functionality to the `SessionManager` class.
// */
//
//import Foundation
//
//extension SessionManager {
//    
//    /**
//     Connects to the socket connection handler.
//     */
//    func connect() {
//        self.socketConnectionHandler.connect()
//    }
//    
//    /**
//     Disconnects from the socket connection handler.
//     */
//    func disconnect() {
//        self.socketConnectionHandler.disconnect()
//    }
//    
//    /**
//     Creates a session with the given host name and session name.
//     
//     - Parameters:
//        - hostName: The host name of the session.
//        - sessionName: The name of the session.
//     
//     - Throws: An error if there is an issue creating the session.
//     */
//    func createSession(hostName: String, sessionName: String) throws {
//        try self.socketEventSender.createSession(hostName: hostName, sessionName: sessionName)
//    }
//    
//    /**
//     Joins a session with the given session ID and host name.
//     
//     - Parameters:
//        - sessionId: The ID of the session to join.
//        - hostName: The host name of the session to join.
//     
//     - Throws: An error if there is an issue joining the session.
//     */
//    func joinSession(sessionId: String, hostName: String) throws {
//        try self.socketEventSender.joinSession(sessionId: sessionId, hostName: hostName)
//    }
//    
//    /**
//     Leaves the current session.
//     
//     - Throws: An error if there is an issue leaving the current session.
//     */
//    func leaveSession() throws {
//        try self.socketEventSender.leaveSession(sessionId: self._session.sessionId)
//    }
//    
//    /**
//     Adds a song to the current session's playlist.
//     
//     - Parameters:
//        - song: The song item to add to the playlist. Must conform to `SongProtocol` protocol.
//     
//     - Throws: An error if there is an issue adding the song to the playlist.
//     */
//    func addSong(song: SongProtocol) throws {
//        try self.socketEventSender.addSong(sessionId: self._session.sessionId, songItem: song)
//    }
//    
//    /**
//     Votes for a song in the current session's playlist.
//     
//     - Parameters:
//        - songId: The ID of the song to vote for.
//        - vote: The vote value. Positive values indicate upvotes, negative values indicate downvotes.
//     
//     - Throws: An error if there is an issue voting for the song.
//     */
//    func voteSong(songId: String, vote: Int) throws {
//        try self.socketEventSender.voteSong(sessionId: self._session.sessionId, songId: songId, vote: vote)
//    }
//}
