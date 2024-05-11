import SwiftUI

struct AuthorizationView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isAuthenticated: Bool
    @ObservedObject var authorizationViewModel = AuthorizationViewModel()
    
   
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Welcome to MusicQueue")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Please log in to continue")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 50)
                
                loginButtons()
                Spacer()
            }
        }
        .onChange(of: authorizationViewModel.isAuthenticated) { isAuthenticated in
            self.isAuthenticated = authorizationViewModel.isAuthenticated
        }
        .onOpenURL { url in
            authorizationViewModel.sessionManager?.application(UIApplication.shared, open: url)
        }
    }

    private func loginButtons() -> some View {
        VStack(spacing: 16) {
            AuthenticationButton(action: authorizationViewModel.handleAppleButtonPressed, text: "Login with Apple Music", systemImageName: "applelogo")
            
            AuthenticationButton(action: authorizationViewModel.handleSpotifyButtonPressed, text: "Login with Spotify", systemImageName: "music.note")
                .padding(.top, 10)
        }
        .padding(.horizontal, 30)
    }
}

class AuthorizationViewModel: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var userSettings: UserSettingsProtocol
    
    @Published var isAuthenticated: Bool = false
    @Published var musicServiceType: MusicServiceType = .unselected
    var sessionManager: SpotifySessionManager?

    func handleAppleButtonPressed() {
        AppleAuthenticationController().authenticate(authenticated: { result in
            DispatchQueue.main.async {
                self.isAuthenticated = result
                self.userSettings.musicServiceType = .apple
            }
        })
        logger.debug("Authenticated with apple music.")
    }

    func handleSpotifyButtonPressed() {
        @Injected var appRemoteManager: SpotifyAppRemoteManagerProtocol
        UserPreferences.setUserMusicService(type: .spotify)

        self.sessionManager = SpotifySessionManager()
        sessionManager?.initiateSession(authenticated: { authenticated in
            DispatchQueue.main.async {
                self.isAuthenticated = authenticated
                self.userSettings.musicServiceType = .spotify
            }
        })
        
        // Connecting here seems to avoid a second navigation away from the app. This isn't use until the media player but worth it to get connected early.
        appRemoteManager.connect(with: "")
        
        
        logger.debug("Authenticated with spotify music.")
    }
}

// MARK: - Preview

//struct AuthorizationView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var temp = false
//        AuthorizationView(isAuthenticated: $temp)
//    }
//}

