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
    
    func emitEventWithAck<T>(event: SocketSendEvent, jsonData: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        socket.emitWithAck(event: event.rawValue, with: jsonData, completion: completion)
    }
    
    func joinSession(sessionId: String, hostName: String, completion: @escaping (Result<JoinSessionResponse, Error>) -> Void) {
        let joinSessionRequest = JoinSessionRequest(sessionId: sessionId, hostName: hostName)
        
        emitEventWithAck(event: .joinSession, jsonData: joinSessionRequest.flatten(), completion: completion)
    }
    
    func addSong(sessionId: String, songItem: AnyMusicItem, completion: @escaping (Result<Bool, Error>) -> Void) {
        let song = Song(id:songItem.id,
                        appleId:songItem.appleID,
                        spotifyId:songItem.spotifyID,
                        uri:songItem.uri,
                        title:songItem.title,
                        artist:songItem.artist,
                        album:songItem.album,
                        artworkUrl:songItem.artworkURL ?? "",
                        votes:songItem.votes)
        let addSongRequest = AddSongRequest(sessionId: sessionId, song: song)
        
        emitEventWithAck(event: .addSong, jsonData: addSongRequest.flatten(), completion: completion)
    }
    
    func leaveSession(sessionId: String, completion: @escaping (Result<LeaveSessionResponse, Error>) -> Void) {
        let leaveSessionRequest = LeaveSessionRequest(sessionId: sessionId)
        
        emitEventWithAck(event: .leaveSession, jsonData: leaveSessionRequest.flatten(), completion: completion)
    }
    
    func removeSong(sessionId: String, songID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let removeSongRequest = RemoveSongRequest(sessionId: sessionId, songId: songID)
        
        emitEventWithAck(event: .removeSong, jsonData: removeSongRequest.flatten(), completion: completion)
    }
    
    func voteSong(sessionId: String, songId: String, vote: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let voteSongRequest = VoteSongRequest(sessionId: sessionId, songId: songId, vote: vote)
        
        emitEventWithAck(event: .voteSong, jsonData: voteSongRequest.flatten(), completion: completion)
    }
}
