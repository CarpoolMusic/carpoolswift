//
//  SocketServiceDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

class SocketDelegate: SocketServiceDelegate {
    
    func socketDidConnect() {
        print("Client connected")
    }
    
    func socketDidDisconnect(with error: Error?) {
        print("Client disconnected")
    }
    
    func socketDidReceiveEvent(event: String, with items: [Any]) {
        switch event {
        case "session created":
            guard let sessionId = items.first as? String else { return }
            handleEvent(.sessionCreated(sessionId))
        case "session joined":
            guard let sessionId = items.first as? String else { return }
            handleEvent(.sessionJoined(sessionId))
        case "left session":
            guard let sessionId = items.first as? String else { return }
            handleEvent(.leftSession(sessionId))
        case "session deleted":
            // Handle this based on the type of the item (String or Dictionary) received in items
            guard let sessionId = items.first as? String else { return }
            handleEvent(.sessionJoined(sessionId))
        case "member left":
            guard let userId = items.first as? String else { return }
            handleEvent(.memberLeft(userId))
        case "queue updated":
            guard let queue = items.first as? [[String: Any]] else { return }
            handleEvent(.queueUpdated(queue))
        case "error":
            guard let error = items.first as? String else { return }
            handleError(.genericError(error))
        case "permissions error":
            guard let error = items.first as? String else { return }
            handleError(.permissionsError(error))
        default:
            print("Unhandled event received: \(event)")
        }
    }
}
