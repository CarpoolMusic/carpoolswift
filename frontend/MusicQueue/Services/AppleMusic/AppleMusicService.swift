//
//  AppleMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import MusicKit
import Combine

class AppleMusicService: MusicService, ObservableObject {
    private var cancellable: AnyCancellable?
    
    // MARK: - Properties
    
    /// Opens a URL using the appropriate system service.
    @Environment(\.openURL) private var openURL
    
    /// The current authorization status of MusicKit.
    @Published var musicAuthorizationStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus
    
    private var cancellables = Set<AnyCancellable>()
    
    
    /// The current authorization status
    var authorizationStatus: MusicServiceAuthStatus {
        switch musicAuthorizationStatus {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        default:
            return .notDetermined
        }
    }
    
    // MARK: - Methods
    
    func authorize() {
        // Implement Apple Music's authorization process here
        switch self.authorizationStatus {
            case .notDetermined:
                Task {
                    let status = await MusicAuthorization.request()
                        DispatchQueue.main.async {
                            self.musicAuthorizationStatus = status
                        }
                }
            case .denied:
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
    }

    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Apple Music's playback here
    }

    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Apple Music's stop playback here
    }

    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Implement Apple Music's fetchArtwork here
    }
    
    func fetchUser() async throws -> User {
        // Fetch the Apple music user
        return User(country: "", displayName: "", email: "")
    }
    
    
    // MARK: - Search results requesting
    
    /// The current search term the user enters.
    @State var searchTerm = ""
    
    /// The albums the app loads using MusicKit that match the current search term.
    @Published var songs: MusicItemCollection<CustomSong> = []
    
    /// A reference to the storage object for recent albums the user previously viewed in the app.
//    @StateObject private var recentAlbumsStorage = RecentAlbumsStorage.shared

    /// Makes a new search request to MusicKit when the current search term changes.
    internal func requestUpdatedSearchResults(for searchTerm: String) {
        print("IN REQUEST")
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    // Issue a catalog search request for albums matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                    searchRequest.limit = 5
                    let searchResponse = try await searchRequest.response()
                    
                    // Update the user interface with the search response.
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
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            // Convert MusicItemCollection<Song> to MusicItemCollection<CustomSong>
            self.songs = MusicItemCollection(searchResponse.songs.map { CustomSong(musicKitSong: $0) })
        }
    }
    
    /// Safely resets the `songs` property on the main thread.
    @MainActor
    private func reset() {
        self.songs = []
    }
}
