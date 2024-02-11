// MARK: - CodeAI Output
/**
 This class manages the session and connection with the server using SocketIO.
 It provides functionality to check if the user is connected, active, and if a song has been added or the queue has been updated.
 */

import Foundation
import SocketIO
import SwiftUI
import Combine
import MusicKit
import os

/**
 An error enum for SessionManager.
 */
enum SessionManagerError: Error {
    case InvalidSessionId
}

/**
 The SessionManager class is an ObservableObject that manages the session and connection with the server using SocketIO.
 */
class SessionManager: ObservableObject {
    let logger = Logger()
    
    /// Indicates if the user is connected to the server.
    @Published var isConnected: Bool = false
    
    /// Indicates if the user's session is active.
    @Published var isActive: Bool = false
    
    /// Indicates if a song has been added to the queue.
    @Published var songAdded: Bool = false
    
    /// Indicates if the queue has been updated.
    @Published var queueUpdated: Bool = false
    
    internal var socketConnectionHandler: SocketConnectionHandler
    internal var socketEventSender: SocketEventSender
    
    private var _isHost: Bool = false
    var _session = Session()
    
    var _queue: SongQueue<AnyMusicItem> = SongQueue()
    
    private var cancellables = Set<AnyCancellable>()
    
    /**
     Initializes a new instance of SessionManager.
     */
    init() {
        self.socketConnectionHandler = SocketConnectionHandler()
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
        
        self._subscribeConnections()
    }
    
    /**
     Deinitializes an instance of SessionManager by disconnecting from the server.
     */
    deinit {
        socketConnectionHandler.disconnect()
    }
    
   /**
     Returns an array of queued songs in the current session's queue.
     
     - Returns: An array of AnyMusicItem objects representing the queued songs.
     */
    func getQueuedSongs() -> [AnyMusicItem] {
        return _queue.getQueueItems()
    }
    
    /**
     Checks if the user is the host of the current session.
     
     - Returns: A boolean value indicating if the user is the host.
     */
    func isHost() -> Bool {
        return self._isHost
    }
    
    private func _subscribeConnections() {
        socketConnectionHandler.$connected.receive(on: DispatchQueue.main).sink { [weak self] connected in
            self?.isConnected = connected
        }.store(in: &cancellables)
        
        socketConnectionHandler.eventPublisher.sink { [weak self] event, items in
            self?.handleEvent(event: event, items: items)
        }.store(in: &cancellables)
    }
    
    /**
     Handles incoming socket events and updates the corresponding properties accordingly.
     
     - Parameters:
       - event: The SocketEvent received from the server.
       - items: An array of AnyMusicItem objects associated with the event.
     */
    private func handleEvent(event: SocketEvent, items: [AnyMusicItem]) {
        // Handle different events and update properties accordingly
    }
}
