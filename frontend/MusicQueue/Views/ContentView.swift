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
        contentViewModel.currentView
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var currentView: AnyView
    
    private let userPreferences: UserPreferences
    private let musicService: AnyMusicService
    
    init() {
        let selectedMusicServiceType = userPreferences.selectedMusicServiceType
        
        if selectedMusicServiceType == .unselected {
            currentView = AuthorizationView()
        } else {
            musicService = getMusicServiceFromType(type: selectedMusicServiceType)
            currentView = musicService.isAuthorized() ? DashboardView() : AuthorizationView()
        }
        
    }
    
    private func getMusicServiceFromType(type: MusicServiceType) -> AnyMusicService? {
        return userPreferences.selectedMusicServiceType == .apple ? AnyMusicService(AppleMusicService()) :
        userPreferences.selectedMusicServiceType == .spotify ? AnyMusicService(SpotifyMusicService()) :
        nil
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SpotifyMusicService())
            .environmentObject(AppleMusicService())
    }
}
