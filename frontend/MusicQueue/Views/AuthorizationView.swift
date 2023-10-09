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
        NavigationView {
            if authorizationViewModel.isAuthenticated {
                AnyView(DashboardView())
            } else {
                AnyView(authenticationContent())
            }
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
            authorizationViewModel.handleSpotifyReturnURL(url: url)
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
    var musicServiceType: MusicServiceType?
    var authenticated: ((Bool) -> (Void))?
    
    var sessionManager: SpotifySessionManager?
    
    func handleAppleButtonPressed() {
        let authController = AppleAuthenticationController()
        print("Apple pressed")
        self.authenticateWithController(controller: authController, service: .apple)
    }
    
    func handleSpotifyButtonPressed() {
        self.sessionManager = SpotifySessionManager()
        let authController = SpotifyAuthenticationController(sessionManager: sessionManager!)
        self.authenticateWithController(controller: authController, service: .spotify)
    }
    
    func handleSpotifyReturnURL(url: URL) {
        self.sessionManager?.returnFromURL(UIApplication.shared, open: url, options: [:])
    }
    
    
    func authenticateWithController(controller: MusicServiceAuthenticationProtocol, service: MusicServiceType) {
        controller.authenticate() { authenticated in
            DispatchQueue.main.async {
                if authenticated {
                    /// seperate this out into a user defaults class that manages persistent state
                    self.setMusicTypeInUserDefaults(type: service)
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    func setMusicTypeInUserDefaults(type: MusicServiceType) {
        UserDefaults.standard.set(type.rawValue, forKey: "musicServiceType")
    }
    
}
// MARK: - Previews

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
