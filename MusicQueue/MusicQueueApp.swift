//
//  MusicQueueApp.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI
import os

@main
struct MusicQueueApp: App {
    
    init() {
        DependencyContainer.shared.registerNotificationCenter(NotificationCenter.default as NotificationCenterProtocol)
        
       
        DependencyContainer.shared.registerSessionManager(sessionManager: SessionManager() as SessionManagerProtocol)
        
        DependencyContainer.shared.registerAPIManager(APIManager() as APIManagerProtocol)
        
        DependencyContainer.shared.registerLogger(CustomLogger() as CustomLoggerProtocol)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

