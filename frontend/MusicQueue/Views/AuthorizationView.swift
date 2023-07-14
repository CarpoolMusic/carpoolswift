//
//  WelcomeView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI
import MusicKit

// MARK: - Welcome View

/// `WelcomeView` is a view that introduces to users the purpose of the MusicAlbums app,
/// and demonstrates best practices for requesting user consent for an app to get access to
/// Apple Music data.
///

struct WelcomeView: View {
    
    // MARK: - Properties
    
    enum MusicServiceType {
        case apple, spotify
    }
    @State var musicServiceType: MusicServiceType?
    
    /// Specific music services
    @StateObject var appleMusicService = AppleMusicService()
    @StateObject var spotifyMusicService = SpotifyMusicService()
    
    /// The generic music service interface
    var musicService: MusicService? {
        switch musicServiceType {
        case .apple:
            return appleMusicService
        case .spotify:
            return spotifyMusicService
        case .none:
            return nil
        }
    }
    
    
    // MARK: - View
    
    /// A decleration of the UI that this view presents.
    var body: some View {
        ZStack {
            gradient
            VStack {
                
                Spacer()
                
                Text("App name")
                    .foregroundColor(.primary)
                    .font(.largeTitle.weight(.semibold))
                    .shadow(radius: 2)
                    .padding(.bottom, 1)
                Text("Some slogan")
                    .foregroundColor(.primary)
                    .font(.title2.weight(.medium))
                    .multilineTextAlignment(.center)
                    .shadow(radius: 1)
                    .padding(.bottom, 16)
                
                Spacer()
                
                Button(action: handleAppleButtonPressed) {
                       HStack {
                           Text("Log in with Apple Music")
                               .font(.headline)
                           Image(systemName: "applelogo") // Replace this with your Apple Music logo
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(height: 24)
                       }
                       .foregroundColor(.white)
                       .padding([.leading, .trailing], 10)
                       .frame(maxWidth: .infinity)
                       .padding()
                   }
                   .background(Color(red: 211/255, green: 17/255, blue: 69/255))
                   .cornerRadius(30)
                   .padding([.leading, .trailing], 20)
                   
                   Button(action: handleSpotifyButtonPressed) {
                       HStack {
                           Text("Log in with Spotify")
                               .font(.headline)
                           Image("spotifyLogo") // Replace this with your Spotify logo
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(height: 24)
                       }
                       .foregroundColor(.white)
                       .padding([.leading, .trailing], 10)
                       .frame(maxWidth: .infinity)
                       .padding()
                   }
                   .background(Color(red: 29/255, green: 185/255, blue: 84/255))
                   .cornerRadius(30)
                   .padding([.leading, .trailing], 20)
                
                if musicAuthorizationStatus == .notDetermined || musicAuthorizationStatus == .denied {
                    Button(action: handleButtonPressed) {
                        buttonText
                            .padding([.leading, .trailing], 10)
                    }
//                    .buttonStyle(.prominent)
                    .colorScheme(.light)
                }
            }
            .colorScheme(.dark)
        }
    }
    
    /// Constructs a gradient to use as the view background.
    private var gradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: (130.0 / 255.0), green: (109.0 / 255.0), blue: (204.0 / 255.0)),
                Color(red: (130.0 / 255.0), green: (130.0 / 255.0), blue: (211.0 / 255.0)),
                Color(red: (131.0 / 255.0), green: (160.0 / 255.0), blue: (218.0 / 255.0))
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .flipsForRightToLeftLayoutDirection(false)
        .ignoresSafeArea()
    }
    
    /// Provides additional text that explains how to get access to Apple Music
    /// after previously denying authorization.
    private var secondaryExplanatoryText: Text? {
        var secondaryExplanatoryText: Text?
        switch musicAuthorizationStatus {
            case .denied:
                secondaryExplanatoryText = Text("Please grant {APP_NAME} access to ")
                    + Text(Image(systemName: "applelogo")) + Text(" Music in Settings.")
            default:
                break
        }
        return secondaryExplanatoryText
    }
    /// A button that the user taps to continue using the app according to the current
    /// authorization status.
    private var buttonText: Text {
        let buttonText: Text
        switch musicAuthorizationStatus {
            case .notDetermined:
                buttonText = Text("Continue")
            case .denied:
                buttonText = Text("Open Settings")
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
        return buttonText
    }
    
    /// Button that user taps to sign in with Apple Music.
    private var appleButtonText: Text {
        return Text("Sign in with Apple Music") + Text(Image(systemName: "applelogo"))
    }
    
    /// BUtton that user taps to sign in with Spotify.
    private var spotifyButtonText: Text {
        return Text("Sign in with Spotify") + Text(Image(systemName: "applelogo"))
    }

    // MARK: - Methods

    /// Allows the user to authorize Apple Music usage when tapping the Continue/Open Setting button.
    private func handleButtonPressed() {
        
        switch musicAuthorizationStatus {
            case .notDetermined:
                Task {
                    // Authenticate with corresponding music service
                    musicService?.authorize { result in
                    }
//                    let musicAuthorizationStatus = await MusicAuthorization.request()
//                    await update(with: musicAuthorizationStatus)
                }
            case .denied:
            // Handle with corresponding music service
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    openURL(settingsURL)
                }
        // Implement Apple Music's authorization process here
        switch musicAuthorizationStatus {
            case .notDetermined:
                Task {
                    let musicAuthorizationStatus = await MusicAuthorization.request()
                    await update(with: musicAuthorizationStatus)
                }
            case .denied:
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    openURL(settingsURL)
                }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
    }
    
    private func handleAppleButtonPressed() {
        // Set the corresponding music service
        musicServiceType = .apple
        handleButtonPressed()
    }
    
    private func handleSpotifyButtonPressed() {
        // Set the corresponding music service
        musicServiceType = .spotify
        handleButtonPressed()
    }

    /// Safely updates the `musicAuthorizationStatus` property on the main thread.
    @MainActor
    private func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        withAnimation {
            self.musicAuthorizationStatus = musicAuthorizationStatus
        }
    }

    // MARK: - Presentation coordinator

    /// A presentation coordinator to use in conjuction with `SheetPresentationModifier`.
    class PresentationCoordinator: ObservableObject {
        static let shared = PresentationCoordinator()
        
        private init() {
            let authorizationStatus = MusicAuthorization.currentStatus
            musicAuthorizationStatus = authorizationStatus
            isWelcomeViewPresented = (authorizationStatus != .authorized)
        }
        
        @Published var musicAuthorizationStatus: MusicAuthorization.Status {
            didSet {
                isWelcomeViewPresented = (musicAuthorizationStatus != .authorized)
            }
        }
        
        @Published var isWelcomeViewPresented: Bool
    }

    // MARK: - Sheet presentation modifier

    /// A view modifier that changes the presentation and dismissal behavior of the welcome view.
    fileprivate struct SheetPresentationModifier: ViewModifier {
        @StateObject private var presentationCoordinator = PresentationCoordinator.shared
        
        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $presentationCoordinator.isWelcomeViewPresented) {
                    WelcomeView(musicAuthorizationStatus: $presentationCoordinator.musicAuthorizationStatus)
                        .interactiveDismissDisabled()
                }
        }
    }
}

// MARK: - View extension

/// Allows the addition of the`welcomeSheet` view modifier to the top-level view.
extension View {
    func welcomeSheet() -> some View {
        modifier(WelcomeView.SheetPresentationModifier())
    }
}

// MARK: - Previews

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(musicAuthorizationStatus: .constant(.notDetermined))
    }
}
