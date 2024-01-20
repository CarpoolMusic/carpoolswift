//
//  SocketServiceProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

protocol SocketServiceProtocol: AnyObject {
    var delegate: SocketServiceDelegate? { get set }
    
    func connect()
    func disconnect()
    func emit(event: String, with items: [String: Any])
    func getSocketId() -> String
}

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

protocol SocketServiceDelegate: AnyObject {
    func socketDidConnect()
    func socketDidDisconnect(with error: Error?)
    func socketDidReceiveEvent(event: String, with items: [Any])
}


