//
//  SpotifyAppRemoteManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifyAppRemoteManager: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    private let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    private let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    
    // MARK: - App Remote
    
    private var connected: Bool = false
    var playerState: SPTAppRemotePlayerState?
    
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
//        appRemote.connectionParameters.accessToken = TokenVault.getTokenFromKeychain()
        appRemote.delegate = self
        return appRemote
    }()
    
    // MARK: - App Remote methods
    
    func connect(with songUri: String) {
        print("connecting with song \(songUri)")
        if (!self.connected) {
            DispatchQueue.main.async {
                self.appRemote.authorizeAndPlayURI(songUri)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.appRemote.connectionParameters.accessToken = TokenVault.getTokenFromKeychain()
                self.appRemote.connect()
            }
        }
    }
    
    // MARK: - Delegate methods
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("APP REMOTE Connection established")
        self.connected = true
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:", error.localizedDescription)
            }
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Connection attempt failed with error \(String(describing: error))")
        self.connected = false
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Session disconnected")
        self.connected = false
    }
    
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("PLAYER STATE CHANGED")
        self.playerState = playerState
    }
    
}

enum AppRemoteManagerError: Error {
    case missingAccessToken(String)
}
