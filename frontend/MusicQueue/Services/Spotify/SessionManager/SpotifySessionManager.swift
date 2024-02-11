/**
This code defines a class `SpotifySessionManager` that manages the authentication and session with the Spotify API. It has properties for the Spotify client ID, redirect URL, and requested scopes. It also has a lazy property `sessionManager` of type `SPTSessionManager` that is responsible for managing the Spotify session.

The `initiateSession` method is used to initiate the Spotify session. It takes a closure as a parameter, which will be called when the session is authenticated. Inside the method, it sets the `authenticated` property and calls `initiateSession(with:)` on the `sessionManager`.

Note: The code assumes that there are additional imports and declarations for classes like `SPTScope` and `SPTSessionManager`, which are not included in the provided code snippet.
*/

import ObjectiveC
import Foundation

class SpotifySessionManager: NSObject {
    // MARK: - Properties
    
    let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    let requestedScopes: SPTScope = [.appRemoteControl]
    
    private lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    var authenticated: ((Bool) -> Void)?
    
    internal lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://api/token"),
           let tokenRefreshURL = URL(string: "https://api/refresh_token") {
//            configuration.tokenSwapURL = tokenSwapUVL
//            configuration.tokenRefreshURL = tokenRefreshURL
//            configuration.playURI = ""
        }
        return SPTSessionManager(configuration: configuration, delegate: self)
    }()
    
    // MARK: - Methods
    
    /// Initiates the Spotify session.
    ///
    /// - Parameter authenticated: A closure to be called when the session is authenticated.
    func initiateSession(authenticated: @escaping (Bool) -> Void) {
        print("TRYING TO CONNECT")
        self.authenticated = authenticated
        sessionManager.initiateSession(with: requestedScopes)
    }
}
