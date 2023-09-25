//
//  AuthorizationView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI
import MusicKit

// MARK: - Authorization View

/// `WelcomeView` is a view that appears when a user needs to choose and
/// authenticate their underlying music source

struct AuthorizationView: View {
    // MARK: - Properties
    
    /// Opens a URL using the appropriate system service.
    @Environment(\.openURL) private var openURL
    
    @ObservedObject var authorizationViewModel = AuthorizationViewModel()
    
    
    // MARK: - View
    
    /// A decleration of the UI that this view presents.
    var body: some View {
        if (authorizationViewModel.isAuthenticated) {
            DashboardView()
        }
        ZStack {
            VStack {
                Spacer()
                
                AppTitleView(title: "Carpool", subtitle: "Some slogan")
                
                Spacer()
                
                /// Apple music login button
                ButtonImageTextView(action: authorizationViewModel.handleAppleButtonPressed, buttonText: Text("Login with Apple Music"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
                
                /// Spotify login button
                ButtonImageTextView(action: authorizationViewModel.handleSpotifyButtonPressed, buttonText: Text("Login with Spotify"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
            }
        }
    }
    
    // MARK: - View Model
    
    class AuthorizationViewModel: ObservableObject {
        
        @Published var isAuthenticated = false
        var musicServiceType: MusicServiceType?
        
        func handleAppleButtonPressed() {
            setMusicTypeInUserDefaults(type: .apple)
            let appleMusicService = AppleMusicService()
            appleMusicService.authorize()
            if appleMusicService.authorizationStatus == .authorized {
                self.isAuthenticated = true
                
            } else {
                // Handle auth failure
            }
        }
        
        func handleSpotifyButtonPressed() {
            setMusicTypeInUserDefaults(type: .spotify)
            let appRemote = SpotifyAppRemoteManager()
            let sessionManager = SpotifySessionManager(appRemote: appRemote)
            let authenticationController = SpotifyAuthenticationController(sessionManager: sessionManager) { authenticated in
                if (authenticated) {
                    self.isAuthenticated = true
                } else {
                    // Handle auth failure with message and new attempt
                }
            }
            // called here and callback above will set authenticated to true when complete
            authenticationController.authenticate()
            
        }
        
        func setMusicTypeInUserDefaults(type: MusicServiceType) {
            UserDefaults.standard.set(type.rawValue, forKey: "musicServiceType")
        }
        
    }
}
// MARK: - Previews

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
