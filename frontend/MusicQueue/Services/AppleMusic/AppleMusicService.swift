//
//  AppleMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import MusicKit
import Combine

class AppleMusicService: ObservableObject {
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Properties
    
    
    /// Opens a URL using the appropriate system service.
    @Environment(\.openURL) private var openURL
    
    /// The current authorization status of MusicKit.
    @Published var musicAuthorizationStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus
    
    private var cancellables = Set<AnyCancellable>()
    private let player = SystemMusicPlayer.shared
    
    
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
    
    // MARK: - Playback
    
    /// The state of the MusicKit player to use for Apple Music playback.
    private var playerState = ApplicationMusicPlayer.shared.state
    
    /// `true` when the album detail view sets a playback queue on the player.
    private var isPlaybackQueueSet = false
    
    /// `true` when the player is playing.
    private var isPlaying: Bool {
        return (playerState.playbackStatus == .playing)
    }
    
    /// The action to perform when the user taps the Play/Pause button.
    func startPlayback(song: GenericSong) async {
        do {
            let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(rawValue: String(song.id)))
            let songs = try await songRequest.response()
            guard let song = songs.items.first else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Song not found"])
            }
            player.queue = [song]
            try await player.prepareToPlay()
            isPlaybackQueueSet = true
            try await player.play()
            print("Playing the song")
        } catch {
            print("Failed trying to play SystemMusicPlayer for song \(error)")
        }
    }
    
    func resumePlayback() async {
        do {
            try await player.play()
        } catch {
            print("Failed to resume playback for Error: \(error)")
        }
        
    }
    
    func skipToNextSong() {
        Task {
            do {
                try await player.skipToNextEntry()
            } catch {
                print("Failed to skip to next song \(error)")
            }
        }
    }
    
    func skipToPrevSong() {
        Task {
            do {
                try await player.skipToPreviousEntry()
            } catch {
                print("Failed to skip to previous song \(error)")
            }
        }
    }
    
    func pausePlayback() {
        player.pause()
    }
    
    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Implement Apple Music's fetchArtwork here
    }
    
    func fetchUser() async throws -> AppleMusicUser {
        // Fetch the Apple music user
        return AppleMusicUser(country: "", displayName: "", email: "")
    }
    
    
    // MARK: - Search results requesting
    
    /// The albums the app loads using MusicKit that match the current search term.
    @Published var songs: MusicItemCollection<Song> = []
    
    /// A reference to the storage object for recent albums the user previously viewed in the app.
    //    @StateObject private var recentAlbumsStorage = RecentAlbumsStorage.shared
    
    /// The current search term the user enters.
    var searchTerm = ""
    
    /// Makes a new search request to MusicKit when the current search term changes.
    internal func requestUpdatedSearchResults(for query: String) {
        self.searchTerm = query
        print(query)
        Task {
            if self.searchTerm.isEmpty {
                print(self.searchTerm)
                await self.reset()
            } else {
                do {
                    print("SErarchign")
                    // Issue a catalog search request for albums matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                    searchRequest.limit = 5
                    let searchResponse = try await searchRequest.response()
                    
                    for song in searchResponse.songs {
                        print("RETUNRED \(song)")
                    }
                    
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
            print(searchResponse)
            // Convert MusicItemCollection<Song> to MusicItemCollection<CustomSong>
//            self.songs = MusicItemCollection(searchResponse.songs.map { CustomSong(musicKitSong: $0) })
        }
    }
    
    /// Safely resets the `songs` property on the main thread.
    @MainActor
    private func reset() {
        self.songs = []
    }
}
