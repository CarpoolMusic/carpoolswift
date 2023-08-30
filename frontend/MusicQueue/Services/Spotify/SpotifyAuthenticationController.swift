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
    
    private let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    
    /// implicitly assigned by passing in
    private let sessionManager: SpotifySessionManager
    private let appRemote: SpotifyAppRemoteManager
    
    var authorizationStatus: MusicServiceAuthStatus = .notDetermined
    
    init(){}
    
    // MARK: - Public protocol methods
    
    func authorize() {
        let requestedScopes: SPTScope = [.appRemoteControl]
        initiateAuthorizationModal(requestedScopes: requestedScopes)
    }
    // MARK: - Private methods
    
    private func initiateAuthorizationModal(requestedScopes: SPTScope) {
        /// Initiate the spotify authentication modal by making call to the session manager
        sessionManager.initiateSession(scope: requestedScopes)
    }
    
    /// This is called from the content view when the app is opened via URL
    private func handleAuthCallback(with url: URL) {
        if UrlMatchesCaller(url: url) {
            if let accessToken = extractAccessTokenFromUrl(url: url) {
                /// save the access token for later use
                self.saveAccessTokenToKeychain(accessToken)
                self.authorizationStatus = .authorized
            }
            /// Notify the session manager that we are back from auth
            sessionManager.notifyReturnFromAuth(url: url)
        }
    }
    
    /// Given that  session manager handles token swap it may make sense for it to store the tokens, especially because its more accesssible from didInitiateSession?
    func extractAccessTokenFromUrl(url: URL) -> String? {
        print(url)
        return "temp"
    }
    
    private func UrlMatchesCaller(url: URL) -> Bool {
        let schemeMatch = url.scheme == SpotifyRedirectURL.scheme
        let hostMatch = url.host == SpotifyRedirectURL.host
        
        return schemeMatch && hostMatch
    }
    
    
    // MARK: - Keychain methods
    
    private func saveAccessTokenToKeychain(_ token: String) {
        keychain.set(token, forKey: accessTokenKey)
    }
    
    private func retrieveAccessTokenFromKeychain() -> String? {
        let token = keychain.get(accessTokenKey)
        return token
    }
}
