//
//  SpotifyAppRemoteManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-12.
//

class SpotifyAppRemoteManager {
    
    private let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    private let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    private let appRemoteDelegate = SpotifyAppRemoteDelegate()
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = appRemoteDelegate
        return appRemote
    }()
    
    
    func extractAccessTokenFromURL(url: URL) throws -> String {
        let parameters = self.appRemote.authorizationParameters(from: url);
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
                appRemote.connectionParameters.accessToken = access_token
                return access_token
        } else {
            let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] ?? "No error description"
            throw AppRemoteManagerError.missingAccessToken(error_description)
        }
    }
    
}

enum AppRemoteManagerError: Error {
    case missingAccessToken(String)
}
