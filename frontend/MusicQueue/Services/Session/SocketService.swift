//
//  SocketService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import SocketIO

class SocketService: SocketServiceProtocol {
    
    weak var delegate: SocketServiceDelegate?
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    init(url: URL) {
        print("URL", url)
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
