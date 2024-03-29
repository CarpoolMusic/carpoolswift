/**
 This code is a Swift implementation of a SocketIO client. It provides methods to connect to a server, emit events, and handle various socket events.
 
 The `SocketSendEvent` enum defines the different types of events that can be sent to the server.
 
 The `SocketEventSender` class is responsible for sending events to the server. It requires a `SocketConnectionHandler` object to establish and maintain the connection.
 
 The `checkConnection()` method checks if the socket is connected. If not, it displays an error message and throws a `SocketError`.
 
 The `emitEvent(event:jsonData:)` method emits an event with the specified event type and JSON data. It first checks if the socket is connected using `checkConnection()`, then calls the `emit(event:with:)` method of the connection object.
 
 The `createSession(hostName:sessionName:)` method creates a session with the specified host name and session name. It creates a `CreateSessionRequest` object, converts it to JSON data using its `jsonData()` method, and emits an event with the `.createSession` event type.
 
 The `joinSession(sessionId:hostName:)` method joins a session with the specified session ID and host name. It creates a `JoinSessionRequest` object, converts it to JSON data using its `jsonData()` method, and emits an event with the `.joinSession` event type.
 
 The `addSong(sessionId:songItem:)` method adds a song to a session. It creates a `Song` object from the provided song item, creates an `AddSongRequest` object with the session ID and song, converts it to JSON data using its `jsonData()` method, and emits an event with the `.addSong` event type.
 
 The `leaveSession(sessionId:)` method leaves a session with the specified session ID. This method is not implemented in the provided code.
 
 The `removeSong(sessionId:songID:)` method removes a song from a session. It creates a `RemoveSongRequest` object with the session ID and song ID, converts it to JSON data using its `jsonData()` method, and emits an event with the `.removeSong` event type.
 
 The `voteSong(sessionId:songId:vote:)` method votes for a song in a session. It creates a `VoteSongRequest` object with the session ID, song ID, and vote value, converts it to JSON data using its `jsonData()` method, and emits an event with the `.voteSong` event type.
 */

import SocketIO
import Foundation

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

protocol SocketEventSenderProtocol {
}

struct SocketEventSender: SocketEventSenderProtocol {
    
    let socket: Socket
    
    init(socket: Socket) {
        self.socket = socket
    }
    
    func connect() {
        self.socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    func checkConnection() throws {
        guard socket.connected else {
            ErrorToast.shared.showToast(message: "Cannot connect to server. Please check connection and reload.")
            throw SocketError(message: "Socket is not connected", stacktrace: Thread.callStackSymbols)
        }
    }
    
    func emitEvent(event: SocketSendEvent, jsonData: Data) throws {
        try checkConnection()
        
        socket.emit(event: event.rawValue, with: [jsonData])
    }
    
    func createSession(hostName: String, sessionName: String) throws {
//        let createSessionRequest = CreateSessionRequest(hostID: hostName, socketID: <#String#>, sessionName: sessionName)
//        
//        let jsonData = try createSessionRequest.jsonData()
//        
//        try emitEvent(event: .createSession, jsonData: jsonData)
    }
    
    func joinSession(sessionId: String, hostName: String) throws {
        let joinSessionRequest = JoinSessionRequest(sessionID: sessionId, userID: hostName)
        
        let jsonData = try joinSessionRequest.jsonData()
        
        try emitEvent(event: .joinSession, jsonData: jsonData)
    }
    
    func addSong(sessionId: String, songItem: AnyMusicItem) throws {
        let song = Song(id:songItem.id,
                        appleID:songItem.appleID,
                        spotifyID:songItem.spotifyID,
                        uri:songItem.uri,
                        title:songItem.title,
                        artist:songItem.artist,
                        album:songItem.album,
                        artworkURL:songItem.artworkURL ?? "",
                        votes:songItem.votes)
        
        let addSongRequest = AddSongRequest(sessionID: sessionId, song: song)
        
        let jsonData = try addSongRequest.jsonData()
        
        try emitEvent(event: .addSong, jsonData: jsonData)
    }
    
    func leaveSession(sessionId: String) throws {
    }
    
    func removeSong(sessionId: String, songID: String) throws {
        let removeSongRequest = RemoveSongRequest(sessionID: sessionId, id: songID)
        
        let jsonData = try removeSongRequest.jsonData()
        
        try emitEvent(event: .removeSong, jsonData: jsonData)
    }
    
    func voteSong(sessionId: String, songId: String, vote: Int) throws {
        let voteSongRequest = VoteSongRequest(sessionID: sessionId, id: songId, vote: vote)
        
        let jsonData = try voteSongRequest.jsonData()
        
        try emitEvent(event:.voteSong, jsonData:jsonData)
    }
}
