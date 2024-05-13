// MARK: - CodeAI Output
/**
 This class handles the connection to a SocketIO server and provides methods for connecting, disconnecting, and emitting events.
 
 Properties:
 - connected: A published boolean value indicating whether the socket is currently connected.
 - manager: A SocketManager instance responsible for managing the socket connection.
 - socket: A SocketIOClient instance representing the socket connection.
 
 Methods:
 - init(): Initializes a new SocketConnectionHandler instance. Sets up the socket manager and socket with a specified URL.
 - connect(): Connects to the socket server.
 - disconnect(): Disconnects from the socket server.
 - emit(event:with:): Emits an event with optional data to the server.
 - getConnectionStatus(): Returns the current status of the socket connection.
 - getSocketId(): Returns the unique identifier of the socket connection.
 - setupHandlers(): Sets up event handlers for incoming events from the server.
 - socketDidReceiveEvent(event:with:): Handles incoming events from the server and updates the connected status or publishes them using an event publisher.
 
 Event Publisher:
 - eventPublisher: A PassthroughSubject that publishes received events along with their associated data as tuples of type (String, [Any]).
 */

import SwiftUI
import SocketIO
import Combine

class Socket {
    @Injected private var notificationCenter: NotificationCenterProtocol
    @Injected private var logger: CustomLoggerProtocol
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    private let socketEventReciever: SocketEventReceiver
    
    init() {
        let url = URL(string: "http://192.168.1.160:3000")!
        self.manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        self.socket = self.manager.defaultSocket
        self.socketEventReciever = SocketEventReceiver(socket: socket)
        
        setupSocketConnectionEvents()
        setupHandlers()
    }
    
    func connect() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // Listen for successful connection
            socket.once(clientEvent: .connect) { _, _ in
                continuation.resume(returning: ())
            }
            
            // Initiating the connection
            socket.connect(timeoutAfter: 5.0) {
                // This block is called on timeout.
                continuation.resume(throwing: SocketError(message: "Timed out when attempting to connect to session."))
            }
        }
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func isConnected() -> Bool {
        return socket.status == .connected
    }
    
    func getSocketId() -> String {
        return socket.sid ?? ""
    }
    
    func emit(event: String, with items: [SocketData] = []) {
        socket.emit(event, items)
    }
    
    func emitWithAck(_ event: SocketSendEvent, _ items: SocketData...) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation { continuation in
            socket.emitWithAck(event.rawValue, with: items).timingOut(after: 10) { data in
                if self.noAck(data: data) {
                    let error = SocketError(message: "No ack received from server.")
                    continuation.resume(throwing: error)
                    return
                }
                if let response = data.first as? [String: Any] {
                    continuation.resume(returning: response)
                } else if let errorString = data.first as? String {
                    continuation.resume(throwing: SocketError(message: errorString))
                } else {
                    continuation.resume(throwing: SocketError(message: "Unknown error"))
                }
            }
        }
    }
    
    private func setupHandlers() {
        self.socket.onAny { [weak self] event in
            print("GOT EVENT \(event)")
            self?.socketEventReciever.receivedEvent(event: event.event, with: event.items ?? [])
        }
    }
    
    private func setupSocketConnectionEvents() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            self?.notificationCenter.post(name: .socketConnectedNotification, object: nil)
            self?.logger.debug("Socket connected")
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            self?.notificationCenter.post(name: .socketDisconnectedNotification, object: nil)
            self?.logger.debug("Socket disconnected")
        }
    }
    
    private func noAck(data: [Any]) -> Bool {
        guard let data = data.first as? String else {
            return false
        }
        
        return data == "NO ACK"
    }
}
