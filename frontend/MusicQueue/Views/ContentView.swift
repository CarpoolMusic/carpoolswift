//
//  ContentView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var spotifyMusicService: SpotifyMusicService
    @EnvironmentObject var appleMusicService: AppleMusicService
    
    
    var body: some View {
        if spotifyMusicService.authorizationStatus == .authorized {
            // Show the main dashboard
        } else {
            // Show the authorization view
            AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
