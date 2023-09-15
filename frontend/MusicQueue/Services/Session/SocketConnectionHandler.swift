//
//  SocketService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import SocketIO
import Combine

/// Responsible for all the low level socket communication with the server
class SocketConnectionHandler: SocketServiceProtocol {
    
    weak var delegate: SocketServiceDelegate?
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    var connected = false
    
    init(url: URL) {
        self.manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        self.socket = self.manager.defaultSocket
        self.setupHandlers()
    }
    
    func connect() {
        self.socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    func emit(event: String, with items: [String: Any] = [:]) {
        socket.emit(event, items)
    }
    
    func getSocketId() -> String {
        return socket.sid ?? ""
    }
    
    private func setupHandlers() {
//        self.socket.on(clientEvent: .connect) { [weak self] data, ack in
//            print("connected")
//        }
//
//        self.socket.on(clientEvent: .disconnect) { [weak self] data, ack in
//            print("disconnecetd")
//        }
        
        self.socket.onAny { [weak self] event in
            self?.socketDidReceiveEvent(event: event.event, with: event.items ?? [])
        }
    }
    
    // MARK: - Subscription
    var eventPublisher = PassthroughSubject<(String, [Any]), Never>()
    
    func socketDidReceiveEvent(event: String, with items: [Any]) {
        eventPublisher.send((event, items))
    }
}
