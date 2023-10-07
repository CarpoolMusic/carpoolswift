//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifySessionManager: NSObject, ServiceSessionManagerProtocol {
    
    let SpotifyClientID = "[your spotify client id here]"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

    private lazy var configuration = SPTConfiguration(
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
        return SPTSessionManager(configuration: self.configuration, delegate: self)
    }()

    func initiateSession(scope: SPTScope) {
        self.sessionManager.initiateSession(with: scope)
    }
    
    func notifyReturnFromAuth(url: URL) {
    /// Notify the session manager that the user has returned from auth modal
    /// This invokes the didInitiateSession session manager delegate function
    self.sessionManager.application(UIApplication.shared, open: url, options: [:])
    }
    
    static func notifyReturnFromUrl(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        sessionManager.application(app, open: url, options: options)
    }
    
    
}
