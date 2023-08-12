//
//  SpotifyServiceAuthorization.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

import KeychainSwift

class SpotifyAuthorization: MusicServiceAuthorization {
    
    private let keychain = KeychainSwift(keyPrefix: "com.app.musicQueue")
    
    private let accessTokenKey = "SpotifyAccessToken"
    private var accessToken: String?
    
    private let sessionManager: SpotifySessionManager
    private let appRemoteManager: SpotifyAppRemoteManager
    private let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    
    // completion handler to communicate the result of async auth to caller
    private var completion: ((Bool, Error?) -> Void)
    
    init(sessionManager: SpotifySessionManager, appRemoteManager: SpotifyAppRemoteManager) {
        self.sessionManager = sessionManager
        self.appRemoteManager = appRemoteManager
    }
    
    
//    var isAuthorized: Bool {
//    }
    
    func initiateAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        /// set up the completion handler
        self.completion = completion
        
        /// Initiate the spotify authentication modal
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(scope: requestedScopes)
    }
    
    /// This is called from the content view when the app is opened via URL
    func handleAuthCallback(with url: URL) {
        if URLMatchesCaller(url: url) {
            do {
                /// set the access token from the response url
                self.accessToken = try self.appRemoteManager.extractAccessTokenFromURL(url: url)
            } catch AppRemoteManagerError.missingAccessToken(let error) {
                print("Error: \(error)")
            } catch {
                print("An unexpected error occured")
            }
            /// Notify the session manager that the user has returned from auth
            self.sessionManager.application(UIApplication.shared, open: url, options: [:])
            
        }
    }
    
    private func URLMatchesCaller(url: URL) -> Bool {
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
