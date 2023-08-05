//
//  SocketServiceProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

enum SocketEvent {
    case connected
    case disconnected
    case sessionCreated(String)
    case sessionJoined(String)
    case leftSession(String)
    case memberLeft(String)
    case sessionDeleted(String)
    case queueUpdated([[String: Any]])
    case error(String)
}

enum SocketError: Error {
    case invalidData
    case connectionFailed
    case genericError(String)
    case permissionsError(String)
    // other error cases
}

protocol SocketServiceDelegate: AnyObject {
    func socketDidConnect()
    func socketDidDisconnect(with error: Error?)
    func socketDidReceiveEvent(event: String, with items: [Any])
}

protocol SocketServiceProtocol: AnyObject {
    var delegate: SocketServiceDelegate? { get set }
    
    func connect()
    func disconnect()
    func emit(event: String, with items: [String: Any])
    func getSocketId() -> String
}

