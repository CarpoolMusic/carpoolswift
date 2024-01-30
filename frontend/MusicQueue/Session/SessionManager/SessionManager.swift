import Foundation
import SocketIO
import SwiftUI
import Combine
import MusicKit
import os

enum SessionManagerError: Error { case InvalidSessionId }

class SessionManager: ObservableObject {
    let logger = Logger()
    
    @Published var isConnected: Bool = false
    @Published var isActive: Bool = false
    
    @Published var songAdded: Bool = false
    @Published var queueUpdated: Bool = false
    
    internal var socketConnectionHandler: SocketConnectionHandler
    internal var socketEventSender: SocketEventSender
    private var _isHost: Bool = false
    
    internal var _session = Session()
    var _queue: SongQueue<AnyMusicItem> = SongQueue()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.socketConnectionHandler = SocketConnectionHandler()
        self.socketEventSender = SocketEventSender(connection: socketConnectionHandler)
        
        self._subscribeConnections()
    }
    
    deinit {
        socketConnectionHandler.disconnect()
    }
   
    func getQueuedSongs() -> Array<AnyMusicItem> {
        return _queue.getQueueItems()
    }
    
    func isHost() -> Bool {
        return self._isHost
    }
    
    private func _subscribeConnections() {
        socketConnectionHandler.$connected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.isConnected = connected
            }
            .store(in: &cancellables)
        
        socketConnectionHandler.eventPublisher
            .sink { [weak self] event, items in
                self?.handleEvent(event: event, items: items)
            }
            .store(in: &cancellables)
    }
    
}
