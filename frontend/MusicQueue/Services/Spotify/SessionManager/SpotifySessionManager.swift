//
//  SpotifySessionManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

import ObjectiveC
import Foundation

class SpotifySessionManager: NSObject {
    // Store these in a secure config file - they cannot stay here !
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
//            self.configuration.tokenSwapURL = tokenSwapURL
//            self.configuration.tokenRefreshURL = tokenRefreshURL
//            self.configuration.playURI = ""
        }
        return SPTSessionManager(configuration: self.configuration, delegate: self)
    }()
    
    func initiateSession(authenticated: @escaping (Bool) -> Void) {
        print("TRYING TO CONNECT")
        // Authenticated gets reassinged in the delegate
        self.authenticated = authenticated
        self.sessionManager.initiateSession(with: requestedScopes)
    }
}
