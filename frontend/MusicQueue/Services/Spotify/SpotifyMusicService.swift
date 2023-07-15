//
//  SpotifyMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

enum AppRemoteConnectionError: Error {
    case notConnected
}

class SpotifyMusicService: MusicService, ObservableObject {
    // MARK: - Properties
    
    private var SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    private var SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    private var accessToken = ""
    
    private let appRemoteDelegate = SpotifyAppRemoteDelegate()
    private let sessionManagerDelegate = SpotifySessionManagerDelegate()
    
    /// The current authorization status of Spotify iOS SDK
    var authorizationStatus: MusicServiceAuthStatus {
        if appRemote.authorizeAndPlayURI("") {
            return .authorized
        } else {
            return .notDetermined // Adjust this depending on your needs.
        }
    }
    
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = appRemoteDelegate // Make sure SpotifyMusicService conforms to SPTAppRemoteDelegate
        return appRemote
    }()
    
    lazy var sessionManager: SPTSessionManager = {
      if let tokenSwapURL = URL(string: "https://[my token swap app domain]/api/token"),
         let tokenRefreshURL = URL(string: "https://[my token swap app domain]/api/refresh_token") {
        self.configuration.tokenSwapURL = tokenSwapURL
        self.configuration.tokenRefreshURL = tokenRefreshURL
        self.configuration.playURI = ""
      }
      let manager = SPTSessionManager(configuration: self.configuration, delegate: sessionManagerDelegate)
      return manager
    }()
    
    init() {
        setupNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    
    // MARK: - Methods
    
    func authorize(completion: @escaping (Result<User, Error>) -> Void) {
        // Implement Spotify's authorization process here
        print("AUTH")
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.appRemote.connectionParameters.accessToken = self.sessionManager.session?.accessToken
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    // This is called from the content view when the app is opened via URL
    func handleAuthCallback(with url: URL) {
        if url.scheme == SpotifyRedirectURL.scheme && url.host == SpotifyRedirectURL.host {
            let parameters = appRemote.authorizationParameters(from: url);
            
            // Notify the session manager that the user has returned from auth
            self.sessionManager.application(UIApplication.shared, open: url, options: [:])
            
            if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
                appRemote.connectionParameters.accessToken = access_token
                self.accessToken = access_token
            } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
                print(error_description)
            }
        }
    }

    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Spotify's playback here
        
        // Wake up the Spotfy app
        appRemote.authorizeAndPlayURI("")
        
        // Check if connected
        guard appRemote.isConnected else {
            completion(.failure(AppRemoteConnectionError.notConnected))
            return
        }

        appRemote.playerAPI?.play("spotify:track:\(songID)", callback: { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }

    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Spotify's stop playback here
        guard appRemote.isConnected else {
            completion(.failure(AppRemoteConnectionError.notConnected))
            return
        }

        appRemote.playerAPI?.pause({ (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }

    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Implement Spotify's fetchArtwork here
        guard appRemote.isConnected else {
           completion(.failure(AppRemoteConnectionError.notConnected))
           return
       }

//       appRemote.imageAPI?.fetchImage(forItemWithURI: "spotify:track:\(songID)", callback: { (result, error) in
//           if let error = error {
//               completion(.failure(error))
//           } else if let image = result as? UIImage {
//               completion(.success(image))
//           }
//       })
    }

    // Other methods as needed...
    func setupNotificationObservers() {
        // Re-connect when the user re-opens the application
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            if let _ = self?.appRemote.connectionParameters.accessToken {
                self?.appRemote.connect()
            }
        }
        
        // Clean up if user is disconnecting
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            if self?.appRemote.isConnected == true {
                self?.appRemote.disconnect()
            }
        }
    }
    
    // MARK: - App Remote Methods
    func isSpotifyInstalled() -> Bool {
        guard let url = URL(string: "spotify:") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func wakeUpSpotifyApp() {
        guard let url = URL(string: "spotify:") else {
            return
        }
        UIApplication.shared.open(url)
    }

}
