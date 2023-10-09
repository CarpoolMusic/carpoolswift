//
//  SocketService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import SocketIO
import Combine

/// Responsible for all the low level socket communication with the server
class SocketConnectionHandler {
   
    @Published var connected: Bool = false
    
    weak var delegate: SocketEventReceiver?
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    init() {
        let url = URL(string: "http://localhost:3000")!
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
        self.socket.onAny { [weak self] event in
            self?.socketDidReceiveEvent(event: event.event, with: event.items ?? [])
        }
    }
    
    // MARK: - Subscription
    var eventPublisher = PassthroughSubject<(String, [Any]), Never>()
    
    func socketDidReceiveEvent(event: String, with items: [Any]) {
        /// Check to see if the event is specific to connection, otherwise forward to subscribers
        switch event {
        case "connected":
            self.connected = true
        case "disconnected":
            self.connected = false
        default:
            eventPublisher.send((event, items))
        }
    }
}
