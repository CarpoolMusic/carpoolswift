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
        DependencyContainer.shared.registerLogger(CustomLogger() as CustomLoggerProtocol)
        
        DependencyContainer.shared.registerNotificationCenter(NotificationCenter.default as NotificationCenterProtocol)
        
        DependencyContainer.shared.registerAPIManager(APIManager() as APIManagerProtocol)
        
        DependencyContainer.shared.registerSessionManager(SessionManager() as SessionManagerProtocol)
        
        DependencyContainer.shared.registerMediaPlayer(MediaPlayer() as MediaPlayerProtocol)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

