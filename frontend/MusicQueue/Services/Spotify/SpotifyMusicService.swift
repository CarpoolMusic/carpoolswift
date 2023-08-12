//
//  SpotifyMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import Combine
import MusicKit

enum AppRemoteConnectionError: Error {
    case notConnected
}

enum SpotifyServiceError: Error {
    case invalidURL
    case missingAccessToken
}

class SpotifyMusicService: MusicServiceProtocol, ObservableObject {
    func skipToNextSong() {
        // Do nothing
    }
    
    func skipToPrevSong() {
        // Do nothing
    }
    
    
    // MARK: - Properties
    
    
    private var SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    private var SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    private var accessToken: String?
    
    private let appRemoteDelegate = SpotifyAppRemoteDelegate()
    private let sessionManagerDelegate = SpotifySessionManagerDelegate()
    
    /// search functionality
    private var cancellables = Set<AnyCancellable>()
    private let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /// The current authorization status of Spotify iOS SDK
    @Published var authorizationStatus: MusicServiceAuthStatus = .notDetermined
    
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
        // Setup the intial notification handlers
        setupNotificationObservers()
        
        /// Note: If the token is from a long time ago and has since expried,
        /// the Spotify iOS SDK will automatically handle token swap
        /// Set initial authorization status
        if let token = self.retrieveAccessTokenFromKeychain() {
            authorizationStatus = .authorized
            self.accessToken = token
        } else {
            authorizationStatus = .notDetermined
        }
        
        print(self.authorizationStatus)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SpotifySessionInitiated"), object: nil)
    }
    
    
    // MARK: - Notification Methods
    
    // Notifications from Delegates or UIApplication
    func setupNotificationObservers() {
        // Re-connect when the user re-opens the application
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            print("Active again")
            if let _ = self?.retrieveAccessTokenFromKeychain() {
                print("RECOONNECTING")
                self?.appRemote.connect()
            }
        }
        
        // Clean up if user is disconnecting
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            if self?.appRemote.isConnected == true {
                self?.appRemote.disconnect()
            }
        }
        
        // Set Access Token and Connect when the user initiates a session
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SpotifySessionInitiated"), object: nil, queue: .main) { [weak self] notification in
            if let token = notification.userInfo?["accessToken"] as? String {
                self?.appRemote.connectionParameters.accessToken = token
                self?.appRemote.connect()
                // Save the token in the keychain for session persistence
                self?.saveAccessTokenToKeychain(token)
                // update the authorzations status of the user
                // Note that we only confirm authorization once we have the token
                self?.authorizationStatus = .authorized
            }
        }
        
        // Update the user token when session manager performs token swap
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SpotifySessionRenewed"), object: nil, queue: .main) { [weak self] notification in
            if let token = notification.userInfo?["accessToken"] as? String {
                // Save the token in the keychain for session persistence
                self?.saveAccessTokenToKeychain(token)
            }
        }
    }
    
    // MARK: - Authorization methods
    
    func authorize() {
        let requestedScopes: SPTScope = [.appRemoteControl]
        /// This invokes the Auth Modal for the spotify login
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    func invokeAuthorizatioModal() {
        /// Set requested scopes
        let requestedScopes: SPTScope = [.appRemoteControl]
        /// This invokes the authorization modal
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
                print("NEW TOKEN: ")
                print(self.accessToken)
            } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
                print(error_description)
            }
        }
    }
    
    // MARK: - Data fetching
    
    internal func fetchUser() async throws -> User {
        guard let url = URL(string: "https://api.spotify.com/v1/me") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        guard let accessToken = self.accessToken else {
            throw SpotifyServiceError.invalidURL
        }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        //        return try JSONDecoder().decode(User.self, from: data)
        return User(country: "", displayName: "", email: "")
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
    
    
    // MARK: - Playback
    
    func startPlayback(song: CustomSong) {
        print("Starting the playback")
        // Ensure app remote is connected
        guard appRemote.isConnected else {
            print("error in startPlayback, appRemote is not conncted")
            return
        }
        print("Playing")
        
        // Wake up the Spotfy app
        appRemote.authorizeAndPlayURI("")
        // Play the song
        appRemote.playerAPI?.play("spotify:track:\(song.id)")
    }
    
    func resumePlayback() {
        print("RESUMING THE PLAYBACKA")
        guard appRemote.isConnected else {
            print("error in resumeplayback, appRemote is not connected")
            return
        }
        appRemote.playerAPI?.resume()
    }
    
    func pausePlayback() {
        // Implement Spotify's stop playback here
        guard appRemote.isConnected else {
            print("error in stopPlayback, appRemote is not conncted")
            return
        }
        
        appRemote.playerAPI?.pause()
    }
    
    func skipToNext() {
        appRemote.playerAPI?.skip(toNext: {
            result, error in
            if let error = error {
                print("Error: Cannot skip to next song \(error)")
            } else {
                // Handle succ
            }
        })
    }
    
    func skipToPrevious()  {
        appRemote.playerAPI?.skip(toPrevious: {
            result, error in
            if let error = error {
                print("Error: Cannot skip to next song \(error)")
            } else {
                // Handle succ
            }
        })
        
    }
    
    
    // MARK: - Searching
    
    /// The albums the app loads using MusicKit that match the current search term.
    @Published var songs: MusicItemCollection<CustomSong> = []
    
    /// The current search term the user enters.
    var searchTerm = ""
    
    
    internal func requestUpdatedSearchResults(for query: String) {
        self.searchTerm = query
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    // Replacing spaces with '+' for the search query
                    let formattedQuery = searchTerm.replacingOccurrences(of: " ", with: "+")
                    
                    // Constructing URL
                    guard let url = URL(string: "https://api.spotify.com/v1/search?q=\(formattedQuery)&type=track&limit=20") else {
                        throw SpotifyServiceError.invalidURL
                    }
                    
                    // Building the request
                    var request = URLRequest(url: url)
                    guard let accessToken = self.accessToken else {
                        throw SpotifyServiceError.missingAccessToken
                    }
                    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    
                    
                    // Sending the request and handling the response
                    let (data, _) = try await URLSession.shared.data(for: request)
                    if let stringData = String(data: data, encoding: .utf8) {
                        print(stringData)
                    }
                    let searchResponse = try JSONDecoder().decode(TrackResponse.self, from: data)
                    await self.apply(searchResponse, for: searchTerm)
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                }
            }
        }
    }
    
    /// Safely updates the `albums` property on the main thread.
    @MainActor
    private func apply(_ searchResponse: TrackResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.songs = MusicItemCollection(searchResponse.tracks.items.map { CustomSong(spotifyTrack: $0) })
        }
    }
    
    /// Safely resets the `songs` property on the main thread.
    @MainActor
    private func reset() {
        self.songs = []
    }
    
    
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
