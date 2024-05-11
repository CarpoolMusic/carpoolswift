//
//  SocketEventReciever.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import SocketIO

class SocketEventReceiver {
    @Injected private var notificationCenter: NotificationCenterProtocol
    @Injected private var logger: CustomLoggerProtocol
    
    private var socket: SocketIOClient
    
    init(socket: SocketIOClient) {
        self.socket = socket
    }
    
    func receivedEvent(event: String, with items: [Any]) {
        switch event {
        case "sessionCreated":
            handleSessionCreatedEvent(items: items)
        case "sessionJoined":
            handleSessionJoinedEvent(items: items)
        case "userJoined":
            handleUserJoinedEvent(items: items)
        case "songAdded":
            handleSongAddedEvent(items: items)
        case "songRemoved":
            notificationCenter.post(name: .songRemovedNotification, object: items)
        case "songVoted":
            notificationCenter.post(name: .songVotedNotification, object: items)
        default:
            print("Unhandled event: \(event)")
        }
    }
    
    func handleSessionCreatedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .sessionCreatedNotification, error)
            return
        }
        
        if let sessionId = firstItem["sessionId"] as? String {
            postResponse(from: .sessionCreatedNotification, sessionId)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .sessionCreatedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .sessionCreatedNotification, error)
        }
    }
    
    func handleSessionJoinedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .sessionJoinedNotification, error)
            return
        }
        
        if let users = firstItem["users"] as? [String] {
            postResponse(from: .sessionJoinedNotification, users)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .sessionJoinedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .sessionJoinedNotification, error)
        }
    }
    
    func handleUserJoinedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .userJoinedNotification, error)
            return
        }
        
        if let user = firstItem["user"] as? String {
            postResponse(from: .userJoinedNotification, user)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .userJoinedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .userJoinedNotification, error)
        }
    }
    
    func handleSongAddedEvent(items: [Any]) {
        guard let firstItem = items.first, let jsonData = try? JSONSerialization.data(withJSONObject: firstItem) else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .songAddedNotification, error)
            return
        }
        
        do {
            let song = try JSONDecoder().decode(SocketSong.self, from: jsonData)
            postResponse(from: .songAddedNotification, song)
        } catch {
            let error = SerializationError(message: "Could not decode song \(jsonData)")
            postError(causedBy: .songAddedNotification, error)
        }
    }
    
    func handleSongRemovedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Unable to deserialize response")
            postError(causedBy: .songRemovedNotification, error)
            return
        }
        
        if let songId = firstItem["songId"] as? String {
            postResponse(from: .songRemovedNotification, songId)
            postResponse(from: .queueUpdatedNotification)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .songRemovedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .songRemovedNotification, error)
        }
    }
    
    func handleSongVotedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Unable to deserialize response")
            postError(causedBy: .songVotedNotification, error)
            return
        }
        
        if let songId = firstItem["songId"] as? String, let vote = firstItem["vote"] as? Int {
            postResponse(from: .songVotedNotification, (songId, vote))
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .songVotedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .songVotedNotification, error)
        }
    }
    
    private func postResponse(from notificationName: Notification.Name) {
        notificationCenter.post(name: notificationName, object: nil)
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: String) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: [String]) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: SocketSong) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: (String, Int)) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
    }
    
    
    private func postError(causedBy notificationName: Notification.Name, _ error: CustomError) {
        notificationCenter.post(name: notificationName, object: error)
        logger.error(error.message)
    }
}
