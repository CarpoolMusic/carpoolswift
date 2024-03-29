/**
 The code provided is a SwiftUI view called `AuthorizationView` that handles the authentication process for a music service. Here's the documentation for each part of the code:
 
 1. `import SwiftUI`: This line imports the SwiftUI framework, which is necessary to use SwiftUI components and features.
 
 2. `struct AuthorizationView: View`: This line defines a struct called `AuthorizationView` that conforms to the `View` protocol. It represents the main view of the authorization process.
 
 3. `@Environment(\.openURL) private var openURL`: This line declares a property wrapper that provides access to the open URL functionality of the environment. It allows the app to handle incoming URLs.
 
 4. `@ObservedObject var authorizationViewModel = AuthorizationViewModel()`: This line declares an observed object property called `authorizationViewModel`, which is an instance of the `AuthorizationViewModel` class. It manages the authentication logic and state.
 
 5. `var body: some View`: This line defines a computed property called `body` that returns a view hierarchy representing the content of this view.
 
 6. The next lines within the computed property define conditional logic based on whether the user is authenticated or not.
 
 7. The `authenticationContent()` function is defined as a private helper function that returns a view hierarchy representing the authentication content when the user is not authenticated.
 
 8. The authentication content consists of a vertical stack (`VStack`) with some spacing and several views, including an app title view and login buttons.
 
 9. The `.onOpenURL { url in ... }` modifier is applied to the authentication content view hierarchy, which listens for incoming URLs and calls a method on the session manager when an URL is opened.
 
 10. The `loginButtons()` function is defined as another private helper function that returns a view hierarchy representing login buttons for different music services (Apple Music and Spotify).
 
 11. Finally, there's a preview provider for this view called `AuthorizationView_Previews`, which provides a preview of the view in Xcode's canvas.
 
 12. The `AuthorizationViewModel` class is defined separately and conforms to the `ObservableObject` protocol. It manages the authentication logic and state for the view.
 
 13. The `isAuthenticated` property is a published property that represents whether the user is authenticated or not.
 
 14. The `sessionManager` property is an optional instance of `SpotifySessionManager`, which handles the Spotify authentication process.
 
 15. The `handleAppleButtonPressed()` method sets the user's music service preference to Apple Music and initiates the Apple Music authentication process using an `AppleAuthenticationController`. Upon successful authentication, it updates the `isAuthenticated` property.
 
 16. The `handleSpotifyButtonPressed()` method sets the user's music service preference to Spotify and initiates the Spotify session using a `SpotifySessionManager`. Upon successful authentication, it updates the `isAuthenticated` property.
 
 Overall, this code represents an authorization view that handles authentication for a music service, with separate helper functions for defining different parts of the view hierarchy and a separate view model class for managing authentication logic and state.
 */
import SwiftUI

struct AuthorizationView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var authorizationViewModel = AuthorizationViewModel()
    
    var body: some View {
        NavigationView {
            authenticationContent()
        }
        .onChange(of: authorizationViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func authenticationContent() -> some View {
        ZStack {
            VStack(spacing: 0) {
                loginButtons()
            }
        }
        .onOpenURL { url in
            authorizationViewModel.sessionManager?.application(UIApplication.shared, open: url)
        }
    }

    private func loginButtons() -> some View {
        VStack(spacing: 16) {
            ButtonImageTextView(action: authorizationViewModel.handleAppleButtonPressed, buttonText: Text("Login with Apple Music"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
            
            ButtonImageTextView(action: authorizationViewModel.handleSpotifyButtonPressed, buttonText: Text("Login with Spotify"), buttonStyle: ButtonBackgroundStyle(), buttonImage: Image(systemName: "applelogo"))
        }
    }
}

class AuthorizationViewModel: ObservableObject { // Added for completeness
    @Published var isAuthenticated: Bool = false
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

// MARK: - Preview

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}

