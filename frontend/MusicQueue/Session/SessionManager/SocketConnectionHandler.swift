//
//  SocketService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import SocketIO
import Combine

class SocketConnectionHandler {
   
    @Published var connected: Bool = false
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    init() {
        let url = URL(string: "http://192.168.1.160:3000")!
        self.manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        self.socket = self.manager.defaultSocket
        self.setupHandlers()
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func emit(event: String, with items: [SocketData] = []) {
        socket.emit(event, items)
    }
    
    func getConnectionStatus() -> SocketIOStatus {
        return self.socket.status
    }
    
    func getSocketId() -> String {
        return socket.sid ?? ""
    }
    
    private func setupHandlers() {
        self.socket.onAny { [weak self] event in
            self?.socketDidReceiveEvent(event: event.event, with: event.items ?? [])
        }
    }
    
    var eventPublisher = PassthroughSubject<(String, [Any]), Never>()
    
    func socketDidReceiveEvent(event: String, with items: [Any]) {
        switch event {
        case "connected":
            self.connected = true
        case "disconnect":
            self.connected = false
        default:
            eventPublisher.send((event, items))
        }
    }
}
