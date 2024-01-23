//
//  AuthorizationView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI
import MusicKit

struct AuthorizationView: View {
    
    @Environment(\.openURL) private var openURL
    @ObservedObject var authorizationViewModel = AuthorizationViewModel()
    
    var body: some View {
        if authorizationViewModel.isAuthenticated {
            AnyView(DashboardView())
        } else {
            AnyView(authenticationContent())
        }
    }
    
    private func authenticationContent() -> some View {
        ZStack {
            VStack {
                Spacer()
                AppTitleView(title: "Carpool", subtitle: "Some slogan")
                Spacer()
                loginButtons()
            }
        }
        .onOpenURL { url in
            authorizationViewModel.sessionManager?.application(UIApplication.shared, open: url)
        }
    }
    
    private func loginButtons() -> some View {
        VStack {
            ButtonImageTextView(action: authorizationViewModel.handleAppleButtonPressed, buttonText: Text("Login with Apple Music"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
            
            ButtonImageTextView(action: authorizationViewModel.handleSpotifyButtonPressed, buttonText: Text("Login with Spotify"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
        }
    }
}

// MARK: - View Model

class AuthorizationViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    var sessionManager: SpotifySessionManager?
    
    func handleAppleButtonPressed() {
        UserPreferences.setUserMusicService(type: .apple)
        
        AppleAuthenticationController().authenticate(authenticated: { result in
            self.isAuthenticated = result
        })
    }
    
    func handleSpotifyButtonPressed() {
        UserPreferences.setUserMusicService(type: .spotify)
        
        self.sessionManager = SpotifySessionManager()
        sessionManager?.initiateSession(authenticated: { authenticated in
            self.isAuthenticated = authenticated
        })
    }
}
// MARK: - Previews

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
