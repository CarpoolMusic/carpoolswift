//
//  SocketEventReceiver.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-07.
//
import Combine

class SocketEventReceiver {
    
    
    static func socketDidReceiveEvent(event: String, with items: [Any]) {
        eventPublisher.send((event, items))
    }
     
//    func socketDidReceiveEvent(event: String, with items: [Any]) {
//        switch event {
//            case "connected":
//                // perform setup
//                print("Connected")
//            case "disconnected":
//                print("Disconnected")
//            case "session created":
//                guard let sessionId = items.first as? String else { return }
//
//            case "session joined":
//                guard let sessionId = items.first as? String else { return }
//            case "left session":
//                guard let sessionId = items.first as? String else { return }
//            case "session deleted":
//                // Handle this based on the type of the item (String or Dictionary) received in items
//                guard let sessionId = items.first as? String else { return }
//            case "member left":
//                guard let userId = items.first as? String else { return }
//            case "queue updated":
//                guard let queue = items.first as? [[String: Any]] else { return }
//            case "error":
//                guard let error = items.first as? String else { return }
//            case "permissions error":
//                guard let error = items.first as? String else { return }
//            default:
//                print("Unhandled event received: \(event)")
//            }
//    }
    
}
