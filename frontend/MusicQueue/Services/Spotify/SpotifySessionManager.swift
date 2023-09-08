//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifySessionManager: NSObject {
    
    private let sessionManagerDelegate: SPTSessionManagerDelegate
    private let configuration: SPTConfiguration
    internal let appRemote: SpotifyAppRemoteManager

    /// Session manager used to handle authenticated sessions
    private lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://[my token swap app domain]/api/token"),
           let tokenRefreshURL = URL(string: "https://[my token swap app domain]/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: sessionManagerDelegate)
        return manager
    }()

    init(appRemote: SpotifyAppRemoteManager) {
        self.appRemote = appRemote
        self.sessionManagerDelegate = self
    }
    
    func initiateSession(scope: SPTScope) {
        self.sessionManager.initiateSession(with: scope)
    }
    
    func notifyReturnFromAuth(url: URL) {
    /// Notify the session manager that the user has returned from auth modal
    /// This invokes the didInitiateSession session manager delegate function
    self.sessionManager.application(UIApplication.shared, open: url, options: [:])
    }
    
    
}
