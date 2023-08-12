//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifySessionManager {
    private let sessionManagerDelegate: SPTSessionManagerDelegate
    private let configuration: SPTConfiguration

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

    init(delegate: SPTSessionManagerDelegate, configuration: SPTConfiguration) {
        self.sessionManagerDelegate = delegate
        self.configuration = configuration
    }
    
    func initiateSession(scope: SPTScope) {
        self.sessionManager.initiateSession(with: scope)
    }
    
}
