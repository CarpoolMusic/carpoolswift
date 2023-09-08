//
//  SocketEventHandler.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-07.
//

enum SocketSendEvent: String {
    case connect
    case disconnect
    case createSession
    case joinSession
    case leaveSession
    case addSong
    case removeSong
    case voteSong
}

class SocketEventSender {
    
    let connection: SocketConnectionHandler
    
    init(connection: SocketConnectionHandler) {
        self.connection = connection
    }
    
    func connect() {
        connection.connect()
    }
    
    func disconnect() {
        connection.disconnect()
    }
    
    func createSession() {
        let event = SocketSendEvent.createSession
        connection.emit(event: event.rawValue, with: [:])
    }
    
    func joinSession(sessionID: String) {
        let event = SocketSendEvent.joinSession
        connection.emit(event: event.rawValue, with: [sessionID: sessionID])
    }
    
    func leaveSession(sessionID: String) {
        let event = SocketSendEvent.leaveSession
        connection.emit(event: event.rawValue, with: [sessionID: sessionID])
    }
    
    func addSong(sessionId: String, song: CustomSong) {
        let event = SocketSendEvent.addSong
        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songData": song.toDictionary()] as [String : Any])
    }
    
    func removeSong(sessionId: String, songID: String) {
        let event = SocketSendEvent.removeSong
        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songID": songID])
    }
    
    func voteSong(sessionId: String, songID: String, vote: Int) {
        let event = SocketSendEvent.voteSong
        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songID": songID, "vote": vote] as [String : Any])
    }
}
