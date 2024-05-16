//
//  DependencyContainer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import Foundation
import SwiftUI

class DependencyContainer {
    static var shared = DependencyContainer()

    private var services: [String: Any] = [:]

    private init() {}

    func register<T>(service: T, as protocolType: T.Type) {
        let key = String(describing: protocolType.self)
        services[key] = service
    }

    static func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let service = shared.services[key] as? T else {
            fatalError("No registered service for type \(key)")
        }
        return service
    }
}

extension DependencyContainer {
    func registerNotificationCenter(_ notificationCenter: NotificationCenterProtocol = NotificationCenter.default) {
        register(service: notificationCenter, as: NotificationCenterProtocol.self)
    }
    
    func registerUserSettings(_ userSettings: UserSettingsProtocol)  {
        register(service: userSettings, as: UserSettingsProtocol.self)
    }
    
    func registerSessionManager(_ sessionManager: any SessionManagerProtocol) {
        register(service: sessionManager, as: (any SessionManagerProtocol).self)
    }
    
    func registerAPIManager(_ apiManager: APIManagerProtocol) {
        register(service: apiManager, as: APIManagerProtocol.self)
    }
    
    func registerMediaPlayer(_ mediaPlayer: MediaPlayerProtocol) {
        register(service: mediaPlayer, as: MediaPlayerProtocol.self)
    }
    
    func registerAppRemoteManager(_ appRemoteManager: SpotifyAppRemoteManagerProtocol) {
        register(service: appRemoteManager, as: SpotifyAppRemoteManagerProtocol.self)
    }
    
    func registerLogger(_ logger: CustomLoggerProtocol) {
        register(service: logger, as: CustomLoggerProtocol.self)
    }
    
}
