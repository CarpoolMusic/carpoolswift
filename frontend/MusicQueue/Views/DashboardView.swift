//
//  DashboardView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import SwiftUI


struct DashboardView: View {
    
    var musicService: MusicService
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DashboardView_Previews: PreviewProvider {
    
    // Just choose spotify (doesn't matter for preview)
    static var musicService: MusicService = SpotifyMusicService()

    static var previews: some View {
        DashboardView(musicService: musicService)
    }
}
