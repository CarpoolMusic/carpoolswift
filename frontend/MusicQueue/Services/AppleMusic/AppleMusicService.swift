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
    
    /// Makes a new search request to MusicKit when the current search term changes.
    private func searchSongs(for searchTerm: String) -> MusicItemCollection<Song> {
        Task {
            if searchTerm.isEmpty {
                return
            } else {
                do {
                    // Issue a catalog search request for songs matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
                    searchRequest.limit = 5
                    let searchResponse = try await searchRequest.response()
                    
                    // Return the songs found
                    return searchResponse.songs
                } catch {
                    print("Search request failed with error: \(error).")
                    self.reset()
                }
            }
        }

    func searchSongs(query: String) -> AnyPublisher<[Song], Error> {
        // Check if the query is empty
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Return an empty array of songs (or handle it as you wish)
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        // Adding percent encoding for the search query
        let formattedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        // Constructing URL
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(formattedQuery)&entity=song") else {
            return Fail(error: MusicServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        // Sending the request and handling the response
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let searchResult = try JSONDecoder().decode(TrackResponse.self, from: data)
                // Transforming Apple's Track objects to your app's Song objects
                return searchResult.tracks.items.map { item in
                    Song(id: item.id, title: item.name, artist: item.artists[0].name, votes: 0)
                }
            }
            .receive(on: DispatchQueue.main)
            .share()  // Use share operator to allow multiple subscriptions
            .eraseToAnyPublisher()

        // Store the cancellable in the cancellables set
        publisher
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)

        return publisher
    }

}
