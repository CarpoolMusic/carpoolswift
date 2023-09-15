//
//  SocketService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import SocketIO

/// Responsible for all the low level socket communication with the server
class SocketConnectionHandler {
    
    weak var delegate: SocketEventReceiver?
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    init(url: URL) {
        self.manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        self.socket = self.manager.defaultSocket
        self.setupHandlers()
    }
    
    func emit(event: String, with items: [String: Any] = [:]) {
        socket.emit(event, items)
    }
    
    func getConnectionStatus() -> SocketIOStatus {
        return self.socket.status
    }
    
    func getSocketId() -> String {
        return socket.sid ?? ""
    }
    
    private func setupHandlers() {
        self.socket.on(clientEvent: .connect) { [weak self] data, ack in
            self?.delegate?.socketDidConnect()
        }
        
        self.socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            self?.delegate?.socketDidDisconnect(with: nil)
        }
        
        self.socket.onAny { [weak self] event in
            self?.delegate?.socketDidReceiveEvent(event: event.event, with: event.items ?? [])
        }
    }
}
