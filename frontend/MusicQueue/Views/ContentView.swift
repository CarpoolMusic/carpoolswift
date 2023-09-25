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
        let userPreferences: UserPreferences = UserPreferences()
        let selectedMusicServiceType = userPreferences.selectedMusicServiceType
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
