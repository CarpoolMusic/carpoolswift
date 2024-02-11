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
