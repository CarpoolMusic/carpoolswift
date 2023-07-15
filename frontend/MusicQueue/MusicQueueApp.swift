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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appleMusicService)
                .environmentObject(spotifyMusicService)
                .onOpenURL { url in
                    spotifyMusicService.handleAuthCallback(with: url)
                }
        }
    }
}

