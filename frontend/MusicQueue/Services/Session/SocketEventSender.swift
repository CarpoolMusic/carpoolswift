//
//  SocketEventHandler.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-07.
//

import SocketIO

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
        guard connection.connected else {
            throw SocketError.notConnected
        }
    }
    
    func createSession(hostName: String, sessionName: String) throws {
        // Build the request
        let createSessionRequest: CreateSessionRequest = CreateSessionRequest(hostID: hostName, sessionName: sessionName)
            
        try checkConnection()
        
        // Send the event
        let event = SocketSendEvent.createSession
        if let json = try? createSessionRequest.jsonData() {
            connection.emit(event: event.rawValue, with: [json])
        }
    }
    
    func joinSession(sessionID: String, hostName: String) throws {
        // Build the request
        let joinSessionRequest: JoinSessionRequest = JoinSessionRequest(sessionID: sessionID, userID: hostName)
        
        try checkConnection()
        
        let event = SocketSendEvent.joinSession
        if let json = try? joinSessionRequest.jsonData() {
            print("SENDING JOIN ", json)
            connection.emit(event: event.rawValue, with: [json])
        }
    }
    
    func leaveSession(sessionID: String) {
        let event = SocketSendEvent.leaveSession
//        connection.emit(event: event.rawValue, with: [sessionID: sessionID])
    }
    
    func addSong(sessionId: String, song: any GenericSong) {
        let event = SocketSendEvent.addSong
//        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songData": song.toJSONData()!] as [String : Any])
    }
    
    func removeSong(sessionId: String, songID: String) {
        let event = SocketSendEvent.removeSong
//        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songID": songID])
    }
    
    func voteSong(sessionId: String, songID: String, vote: Int) {
        let event = SocketSendEvent.voteSong
//        connection.emit(event: event.rawValue, with: ["sessionId": sessionId, "songID": songID, "vote": vote] as [String : Any])
    }
}
