//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifySessionManager: NSObject, SPTSessionManagerDelegate {
    let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    var authenticated: ((Bool) -> Void)?
    let requestedScopes: SPTScope = [.appRemoteControl]
    
    // MARK: - Session Manager

    private lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )

    /// Session manager used to handle authenticated sessions
    private lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://api/token"),
           let tokenRefreshURL = URL(string: "https://api/refresh_token") {
//            self.configuration.tokenSwapURL = tokenSwapURL
//            self.configuration.tokenRefreshURL = tokenRefreshURL
//            self.configuration.playURI = ""
        }
        return SPTSessionManager(configuration: self.configuration, delegate: self)
    }()
    
    // MARK: - Session Manager methods

    func initiateSession(authenticated: @escaping (Bool) -> Void) {
        // Set callback to global scope so that the delegate can see it
        print("TRYING TO CONNECT")
        self.authenticated = authenticated
        self.sessionManager.initiateSession(with: requestedScopes)
    }
    
    // MARK: - Delegate methods
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
        TokenVault.upsertTokenToKeychain(token: session.accessToken)
        self.authenticated?(true)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Failed to establish session with error \(error)")
        self.authenticated?(false)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Void {
        print("Handling the URL open")
        print("URL", url)
        sessionManager.application(app, open: url, options: options)
        
    }
}
