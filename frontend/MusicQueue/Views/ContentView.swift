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
        ZStack {
            contentViewModel.currentView
            if contentViewModel.isAuthorizing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                    .background(Color.black.opacity(0.5).ignoresSafeArea())
            }
        }
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var currentView: AnyView
    
    /// `true` if we are currently trying to authorize the user
    @Published var isAuthorizing = false
    
    init() {
        let userPreferences: UserPreferences
        let selectedMusicServiceType = userPreferences.selectedMusicServiceType
        
        /// If the user has not selected a music service yet, send them to auth page
        /// Otherwise attempt to authorize them
        if selectedMusicServiceType == .unselected {
            currentView = AnyView(AuthorizationView())
        } else {
            authorizeWithSelectedService(serviceType: selectedMusicServiceType)
        }
    }
    
    private func authorizeWithSelectedService(serviceType: MusicServiceType) {
        /// Notify the view that we are currently trying to authorize
        self.isAuthorizing = true
        
        /// Attempt to authorize the user with their selected music service
        let musicService = getMusicServiceFromType(type: serviceType)
        musicService.authorize()
        currentView = musicService.isAuthorized() ? DashboardView(musicService) : AuthorizationView()
    }
    
    private func getMusicServiceFromType(type: MusicServiceType) -> AnyMusicService {
        return userPreferences.selectedMusicServiceType == .apple ? AnyMusicService(AppleMusicService()) : AnyMusicService(SpotifyMusicService())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SpotifyMusicService())
            .environmentObject(AppleMusicService())
    }
}
