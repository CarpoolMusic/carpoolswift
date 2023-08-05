//
//  AnyMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import MusicKit
import Combine

class AnyMusicService: MusicService, ObservableObject {
    
    private let base: MusicService
    
    // Published songs property
    @Published var songs: MusicItemCollection<CustomSong> = []
    
    // Published search term
    @Published var searchTerm: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    

    var authorizationStatus: MusicServiceAuthStatus {
        base.authorizationStatus
    }

    init(_ base: MusicService) {
        self.base = base
        bindBase()
        reverseBindSearchTerm()
    }

    func authorize() {
        base.authorize()
    }

    func fetchUser() async throws -> User {
        try await base.fetchUser()
    }

    func startPlayback(songID: String) {
        base.startPlayback(songID: songID)
    }

    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void) {
        base.stopPlayback(completion: completion)
    }

    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        base.fetchArtwork(for: songID, completion: completion)
    }
    
    func requestUpdatedSearchResults(for searchTerm: String) {
        base.requestUpdatedSearchResults(for: searchTerm)
    }
    
    // MARK: - Private functions
    
    private func bindBase() {
        if let base = base as? AppleMusicService {
            base.$songs.assign(to: &$songs)
        }
        if let base = base as? SpotifyMusicService {
            base.$songs.assign(to: &$songs)
        }
        
    }
    
    private func reverseBindSearchTerm() {
        $searchTerm
        .sink { [weak base] in
            base?.searchTerm = $0
        }
        .store(in: &cancellables)
    }
    
}

class MusicServiceViewModel: ObservableObject {
    @Published var musicService: AnyMusicService?

    // Other methods and properties specific to your View
    // This ViewModel can also observe changes from the MusicService
}
