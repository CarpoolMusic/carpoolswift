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
        
        DependencyContainer.shared.registerUserSettings(UserSettings() as UserSettingsProtocol)
        
        DependencyContainer.shared.registerNotificationCenter(NotificationCenter.default as NotificationCenterProtocol)
        
        /* Register spotify appRemoteManager for spotify media player.
        This is ultimatley not needed until later, however, it requires navigation away from the app. We should try and attempt to combine this with the authorization navigation to avoid navigating away twice. Putting in the dependency container since we should try and mantain this connection for the life of the app to avoid the number of times we need to navigate away. If we can find away to avoid the navigation altogether then this connection can be more on demand and live in the media player.
         */
        DependencyContainer.shared.registerAppRemoteManager(SpotifyAppRemoteManager() as SpotifyAppRemoteManagerProtocol)
        
        DependencyContainer.shared.registerAPIManager(APIManager() as APIManagerProtocol)
        
        DependencyContainer.shared.registerSessionManager(SessionManager() as (any SessionManagerProtocol))
        
        DependencyContainer.shared.registerMediaPlayer(MediaPlayer() as MediaPlayerProtocol)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

