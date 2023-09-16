//
//  SpotifyAppRemoteManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//
class SpotifyAppRemoteManager: NSObject {
    
    private let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    private let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    
    // Determines whether or not appRemote is connected
    @Published var connectionStatus : ConnectionStatus = .undetermined
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func connect(accessToken: String) {
        setAccessToken(accessToken: accessToken)
        // wake up the spotify app before trying to connect
        self.appRemote.authorizeAndPlayURI("")
        // connection handled in delegate
        self.appRemote.connect()
    }
    
    private func setAccessToken(accessToken: String) {
        self.appRemote.connectionParameters.accessToken = accessToken
    }
    
    
//    func extractAccessTokenFromURL(url: URL) throws -> String {
//        let parameters = self.appRemote.authorizationParameters(from: url);
//
//        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
//                appRemote.connectionParameters.accessToken = access_token
//                return access_token
//        } else {
//            let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] ?? "No error description"
//            throw AppRemoteManagerError.missingAccessToken(error_description)
//        }
//    }
    
}

enum AppRemoteManagerError: Error {
    case missingAccessToken(String)
}
