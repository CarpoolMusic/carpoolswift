//
//  SpotifyServiceAuthorization.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

import KeychainSwift

class SpotifyAuthenticationController: MusicServiceAuthenticationProtocol {
    
    // MARK: - Initialization
    private let keychain = KeychainSwift(keyPrefix: "com.app.musicQueue")
    
    private let accessTokenKey = "SpotifyAccessToken"
    
    private let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    let sessionManager: ServiceSessionManagerProtocol
    
    var authorizationStatus: MusicServiceAuthStatus = .notDetermined
    
    var authenticated: Bool = false
    
    
    init(sessionManager: ServiceSessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - Public protocol methods
    
    var isAuthorized: Bool {
        return self.authorizationStatus == .authorized
    }
    
    func authenticate(authenticated: @escaping (Bool) -> Void) {
        let requestedScopes: SPTScope = [.appRemoteControl]
        /// Initiate the spotify authentication modal by making call to the session manager
        sessionManager.initiateSession(scope: requestedScopes, authenticated: authenticated)
    }
}
