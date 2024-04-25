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

class AuthorizationViewModel: ObservableObject { // Added for completeness
    @Injected private var logger: CustomLoggerProtocol
    
    @Published var isAuthenticated: Bool = false
    var sessionManager: SpotifySessionManager?

    func handleAppleButtonPressed() {
        UserPreferences.setUserMusicService(type: .apple)

        AppleAuthenticationController().authenticate(authenticated: { result in
            DispatchQueue.main.async {
                self.isAuthenticated = result
            }
        })
        
        logger.debug("Authenticated with apple music.")
    }

    func handleSpotifyButtonPressed() {
        UserPreferences.setUserMusicService(type: .spotify)

        self.sessionManager = SpotifySessionManager()
        sessionManager?.initiateSession(authenticated: { authenticated in
            DispatchQueue.main.async {
                self.isAuthenticated = authenticated
            }
        })
        
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

