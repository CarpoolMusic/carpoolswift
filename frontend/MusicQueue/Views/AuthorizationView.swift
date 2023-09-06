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
        ZStack {
            VStack {
                Spacer()
                
                AppTitleView(title: "Carpool", subtitle: "Some slogan")
                
                Spacer()
                
                /// Apple music login button
                LoginButtonView(action: authorizationViewModel.handleAppleButtonPressed, buttonText: Text("Login with Apple Music"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
                
                /// Spotify login button
                LoginButtonView(action: authorizationViewModel.handleSpotifyButtonPressed, buttonText: Text("Login with Spotify"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
            }
        }
    }
    
    struct LoginButtonView: View {
        let action: () -> Void
        let buttonText: Text
        let buttonStyle: ButtonBackgroundStyle
        let buttonImage: Image
        
        var body: some View {
            Button(action: action) {
                HStack {
                    buttonText
                    buttonImage
                }
            }
            .buttonStyle(ButtonBackgroundStyle())
        }
    }
    
    struct ButtonBackgroundStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(configuration.isPressed ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8.0)
        }
    }
    
    struct AppTitleView: View {
        let title: String
        let subtitle: String
        
        var body: some View {
            Text(title)
                .foregroundColor(.primary)
                .font(.largeTitle.weight(.semibold))
                .shadow(radius: 2)
                .padding(.bottom, 1)
            Text(subtitle)
                .foregroundColor(.primary)
                .font(.title2.weight(.medium))
                .multilineTextAlignment(.center)
                .shadow(radius: 1)
                .padding(.bottom, 16)
        }
        
    }
    
// MARK: - View Model

class AuthorizationViewModel: ObservableObject {
    
    var musicServiceType: MusicServiceType?
    
    func handleAppleButtonPressed() {
        setMusicTypeInUserDefaults(type: .apple)
        let appleMusicService = AppleMusicService()
        appleMusicService.authorize()
    }
    
    func handleSpotifyButtonPressed() {
        setMusicTypeInUserDefaults(type: .spotify)
        let appRemote = SpotifyAppRemoteManager()
        let sessionManager = SpotifySessionManager(appRemote: appRemote)
        let authenticationController = SpotifyAuthenticationController(sessionManager: sessionManager) { authenticated in
            if (authenticated) {
                // Successfully authenticated so move on to dashboard
                DashboardView()
            } else {
                // Handle auth failure with message and new attempt
            }
        }
        authenticationController.authenticate()
        
    }
    
    func setMusicTypeInUserDefaults(type: MusicServiceType) {
        UserDefaults.standard.set(type.rawValue, forKey: "musicServiceType")
    }
    
}

// MARK: - Previews

struct AuthorizationView_Previews: PreviewProvider {
    // Create instances of AppleMusicService and SpotifyMusicService
    @ObservedObject static var appleMusicService = AppleMusicService()
    @ObservedObject static var spotifyMusicService = SpotifyMusicService()
    
    static var previews: some View {
        AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService, musicServiceType: .constant(.spotify))
    }
}
