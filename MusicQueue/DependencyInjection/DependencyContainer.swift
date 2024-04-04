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
            fatalError("No regisered service for type \(key)")
        }
        return service
    }
}

extension DependencyContainer {
    func registerNotificationCenter(_ notificationCenter: NotificationCenterProtocol = NotificationCenter.default) {
        register(service: notificationCenter, as: NotificationCenterProtocol.self)
    }
    
    func registerSessionManager(sessionManager: SessionManagerProtocol) {
        register(service: sessionManager, as: SessionManagerProtocol.self)
    }
    
    func registerAPIManager(_ apiManager: APIManagerProtocol = APIManager()) {
        register(service: apiManager, as: APIManagerProtocol.self)
    }
    
    func registerLogger(_ logger: CustomLoggerProtocol = CustomLogger()) {
        register(service: logger, as: CustomLoggerProtocol.self)
    }
}
