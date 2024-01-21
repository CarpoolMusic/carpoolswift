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
            throw SocketError(message: "Socket is not connected", stacktrace: Thread.callStackSymbols)
        }
    }
    
    func createSession(hostName: String, sessionName: String) throws {
        let createSessionRequest: CreateSessionRequest = CreateSessionRequest(hostID: hostName, sessionName: sessionName)
            
        try checkConnection()
        
        let event = SocketSendEvent.createSession
        let json = try createSessionRequest.jsonData()
        connection.emit(event: event.rawValue, with: [json])
    }
    
    func joinSession(sessionId: String, hostName: String) throws {
        let joinSessionRequest: JoinSessionRequest = JoinSessionRequest(sessionID: sessionId, userID: hostName)
        
        try checkConnection()
        
        let event = SocketSendEvent.joinSession
        let json = try joinSessionRequest.jsonData()
        connection.emit(event: event.rawValue, with: [json])
    }
    
    func addSong(sessionId: String, song: AnyMusicItem) throws {
        let song = Song(service: song.service, id: song.id, uri: song.uri, title: song.title, artist: song.artist, album: song.album, artworkURL: song.artworkURL ?? "", votes: song.votes)
        let addSongRequest: AddSongRequest = AddSongRequest(sessionID: sessionId, song: song)
        
        try checkConnection()
        
        let event = SocketSendEvent.addSong
        let json = try addSongRequest.jsonData()
        connection.emit(event: event.rawValue, with: [json])
    }
    
    func leaveSession(sessionId: String) throws {
//        let event = SocketSendEvent.leaveSession
//        connection.emit(event: event.rawValue, with: [sessionID: sessionID])
    }
    
    func removeSong(sessionId: String, songID: String) throws {
        let removeSongRequest: RemoveSongRequest = RemoveSongRequest(sessionID: sessionId, songID: songID)
        
        try checkConnection()
        
        let event = SocketSendEvent.removeSong
        let json = try removeSongRequest.jsonData()
        connection.emit(event: event.rawValue, with: [json])
    }
    
    func voteSong(sessionId: String, songId: String, vote: Int) throws {
        let voteSongRequest: VoteSongRequest = VoteSongRequest(sessionID: sessionId, songID: songId, vote: vote)
       
        try checkConnection()
        
        let event = SocketSendEvent.voteSong
        let json = try voteSongRequest.jsonData()
        connection.emit(event: event.rawValue, with: [json])
    }
}
