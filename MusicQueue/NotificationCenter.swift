//
//  NotificationCenterProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import Foundation

protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?)
    func post(name: NSNotification.Name, object: Any?)
    // Include other methods as needed.
}

extension NotificationCenter: NotificationCenterProtocol {}

// Socket notifications
extension Notification.Name {
    static let socketConnectedNotification = Notification.Name("socketConnectedNotifcation")
    static let socketDisconnectedNotification = Notification.Name("socketDisconnectedNotifcation")
}

// Session notificaitons
extension Notification.Name {
    static let sessionCreatedNotification = Notification.Name("sessionCreatedNotification")
    static let sessionJoinedNotification = Notification.Name("sessionJoinedNotification")
    static let userJoinedNotification = Notification.Name("userJoinedNotification")
    static let songVotedNotification = Notification.Name("songVotedNotification")
}

// Queue Notifications
extension Notification.Name {
    static let queueUpdatedNotification = Notification.Name("queueUpdatedNotification")
    static let songAddedNotification = Notification.Name("songAddedNotification")
    static let songRemovedNotification = Notification.Name("songRemovedNotification")
}
