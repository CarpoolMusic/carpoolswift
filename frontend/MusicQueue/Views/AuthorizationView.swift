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
    
    
    @ObservedObject var appleMusicService: AppleMusicService
    @ObservedObject var spotifyMusicService: SpotifyMusicService
    
    enum MusicServiceType {
        case apple, spotify
    }
    @State var musicServiceType: MusicServiceType?
    
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
                
                Text("Carpool")
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
                           Image(systemName: "appleLogo") // Replace this with your Spotify logo
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
    
    /// A button that the user taps to continue using the app according to the current
    /// authorization status.
    private var buttonText: Text {
        let buttonText: Text
        switch musicService?.authorizationStatus {
            case .notDetermined:
                buttonText = Text("Continue")
            case .denied:
                buttonText = Text("Open Settings")
            default:
            fatalError("No button should be displayed for current authorization status: \(musicService!.authorizationStatus).")
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
    private func handleAppleButtonPressed() {
        // Set the corresponding music service
        musicServiceType = .apple
        musicService?.authorize { result in
            switch result {
                case .success(let user):
                    print("User successfully authroized. Name: \(user.name), ID: \(user.id)")
                case .failure(let error):
                    print("Authorization failed with error: \(error)")
            }
        }
    }
    
    private func handleSpotifyButtonPressed() {
        // Set the corresponding music service
        musicServiceType = .spotify
        print("HERE")
        musicService?.authorize { result in
            switch result {
            case .success(let user):
                print("User successfully authroized. Name: \(user.name), ID: \(user.id)")
            case .failure(let error):
                print("Authorization failed with error: \(error)")
            }
        }
        print("HERERE")
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
        
        // Create instances of AppleMusicService and SpotifyMusicService
        @ObservedObject var appleMusicService = AppleMusicService()
        @ObservedObject var spotifyMusicService = SpotifyMusicService()
        
        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $presentationCoordinator.isWelcomeViewPresented) {
                    AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService)
                        .interactiveDismissDisabled()
                }
        }
    }
}

// MARK: - View extension

/// Allows the addition of the`welcomeSheet` view modifier to the top-level view.
extension View {
    func welcomeSheet() -> some View {
        modifier(AuthorizationView.SheetPresentationModifier())
    }
}

// MARK: - Previews

struct AuthorizationView_Previews: PreviewProvider {
    // Create instances of AppleMusicService and SpotifyMusicService
    @ObservedObject static var appleMusicService = AppleMusicService()
    @ObservedObject static var spotifyMusicService = SpotifyMusicService()
    
    static var previews: some View {
        AuthorizationView(appleMusicService: appleMusicService, spotifyMusicService: spotifyMusicService)
    }
}
