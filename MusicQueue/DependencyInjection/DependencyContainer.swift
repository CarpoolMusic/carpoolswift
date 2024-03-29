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
    
    func registerLazy<T>(_ protocolType: T.Type, factory: @escaping () -> T) {
        let key = String(describing: protocolType)
        services[key] = factory
    }
    
    static func resolveLazy<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let factory = shared.services[key] as? () -> T {
            return factory()
        } else {
            fatalError("No registered factory for type \(key)")
        }
    }
}

extension DependencyContainer {
    func registerNotificationCenter(_ notificationCenter: NotificationCenterProtocol = NotificationCenter.default) {
        register(service: notificationCenter, as: NotificationCenterProtocol.self)
    }
    
    func registerSessionManager(sessionId: String, sessionName: String, hostName: String) {
        registerLazy(SessionManager.self) {
            // This block is only executed when SessionManager is first resolved
            return SessionManager(sessionId: sessionId, sessionName: sessionName, hostName: hostName)
        }
    }
    
    func registerAPIManager(_ apiManager: APIManagerProtocol = APIManager()) {
        register(service: apiManager, as: APIManagerProtocol.self)
    }
}
