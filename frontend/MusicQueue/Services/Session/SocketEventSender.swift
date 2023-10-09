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
        connection.connect()
    }
    
    func checkConnection() throws {
        if !connection.connected {
            throw SocketError.notConnected
        }
    }
    
    
    func createSession() throws {
        do {
            try checkConnection()
            let event = SocketSendEvent.createSession
            connection.emit(event: event.rawValue, with: [:])
        } catch SocketError.notConnected {
            // rethrow 
            throw SocketError.notConnected
        }
    }
    
    func joinSession(sessionID: String) {
        let event = SocketSendEvent.joinSession
        connection.emit(event: event.rawValue, with: [sessionID: sessionID])
    }
    
    func leaveSession(sessionID: String) {
        let event = SocketSendEvent.leaveSession
        connection.emit(event: event.rawValue, with: [sessionID: sessionID])
    }
    
    func addSong(sessionId: String, song: GenericSong) {
        let event = SocketSendEvent.addSong
        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songData": song.toJSONData()!] as [String : Any])
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
