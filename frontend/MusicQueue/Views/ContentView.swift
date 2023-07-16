//
//  ContentView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct ContentView: View {
    
    // Observed music services from main
    @EnvironmentObject var spotifyMusicService: SpotifyMusicService
    @EnvironmentObject var appleMusicService: AppleMusicService
    
    // Observed session manager from main
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var selectedMusicServiceType: MusicServiceType? = {
        if let stringValue = UserDefaults.standard.string(forKey: "musicServiceType"),
           let rawValue = MusicServiceType(rawValue: stringValue) {
            return rawValue
        }
        return .none
    }()
    
    
    var body: some View {
        VStack {
            switch selectedMusicServiceType {
            case .spotify:
                if spotifyMusicService.authorizationStatus == .authorized {
                    DashboardView(musicService: AnyMusicService(spotifyMusicService), sessionManager: sessionManager)
                } else {
                    AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService, musicServiceType: $selectedMusicServiceType)
                }
            case .apple:
                if appleMusicService.authorizationStatus == .authorized {
                    DashboardView(musicService: AnyMusicService(appleMusicService), sessionManager: sessionManager)
                } else {
                    AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService, musicServiceType: $selectedMusicServiceType)
                }
            case .none:
                // The user has not selected a music service yet
                AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService, musicServiceType: $selectedMusicServiceType)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SpotifyMusicService())
            .environmentObject(AppleMusicService())
    }
}
