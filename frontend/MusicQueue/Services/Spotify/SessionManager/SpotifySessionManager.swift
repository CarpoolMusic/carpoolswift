//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifySessionManager: NSObject {
    
    let SpotifyClientID = "[your spotify client id here]"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )

    /// Session manager used to handle authenticated sessions
    private lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://[my token swap app domain]/api/token"),
           let tokenRefreshURL = URL(string: "https://[my token swap app domain]/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()

    func initiateSession(scope: SPTScope) {
        self.sessionManager.initiateSession(with: scope)
    }
    
    func notifyReturnFromAuth(url: URL) {
    /// Notify the session manager that the user has returned from auth modal
    /// This invokes the didInitiateSession session manager delegate function
    self.sessionManager.application(UIApplication.shared, open: url, options: [:])
    }
    
    
}
