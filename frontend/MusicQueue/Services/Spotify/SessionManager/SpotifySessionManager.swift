//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifySessionManager: NSObject, ServiceSessionManagerProtocol {
    let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    var authenticated: ((Bool) -> Void)?

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

    func initiateSession(scope: SPTScope, authenticated: @escaping (Bool) -> Void) {
        /// callback that the delegate can set to notify the user
        self.authenticated = authenticated
        self.sessionManager.initiateSession(with: scope)
    }
    
    func returnFromURL(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Void {
        self.sessionManager.application(app, open: url, options: options)
    }    
}
