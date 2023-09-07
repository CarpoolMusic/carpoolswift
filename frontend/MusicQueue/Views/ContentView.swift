//
//  ContentView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        if contentViewModel.isAuthenticated {
            DashboardView()
        }
        AuthorizationView()
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    
    
    init() {
        let userPreferences: UserPreferences
        let selectedMusicServiceType = userPreferences.selectedMusicServiceType
        let musicService = getMusicServiceFromType(type: selectedMusicServiceType)
        self.isAuthenticated = musicService.isAuthorized()
    }
    
    private func getMusicServiceFromType(type: MusicServiceType) -> AnyMusicService {
        return type == .apple ? AnyMusicService(AppleMusicService()) : AnyMusicService(SpotifyMusicService())
    }
    
//    private func authorizeWithSelectedService(serviceType: MusicServiceType) {
//        /// Notify the view that we are currently trying to authorize
//        self.isAuthorizing = true
//
//        /// Attempt to authorize the user with their selected music service
//        let musicService = getMusicServiceFromType(type: serviceType)
//        musicService.authorize()
//        currentView = musicService.isAuthorized() ? DashboardView(musicService) : AuthorizationView()
//    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SpotifyMusicService())
            .environmentObject(AppleMusicService())
    }
}
