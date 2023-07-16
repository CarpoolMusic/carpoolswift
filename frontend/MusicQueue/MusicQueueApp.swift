//
//  MusicQueueApp.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

@main
struct MusicQueueApp: App {
    
    /// Specific music services
    @StateObject var appleMusicService = AppleMusicService()
    @StateObject var spotifyMusicService = SpotifyMusicService()
    
    /// Session Manager
    @StateObject var sessionManager = SessionManager(socketService: SocketService(url: URL(string: "http://192.168.1.24:3000")!))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appleMusicService)
                .environmentObject(spotifyMusicService)
                .environmentObject(sessionManager)
                .onOpenURL { url in
                    spotifyMusicService.handleAuthCallback(with: url)
                }
        }
    }
}

