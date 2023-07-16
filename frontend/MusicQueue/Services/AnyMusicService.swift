//
//  AnyMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

class AnyMusicService: ObservableObject {
    private let base: MusicService

    var authorizationStatus: MusicServiceAuthStatus {
        base.authorizationStatus
    }

    init(_ base: MusicService) {
        self.base = base
    }

    func authorize() {
        base.authorize()
    }

    func fetchUser() async throws -> User {
        try await base.fetchUser()
    }

    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        base.startPlayback(songID: songID, completion: completion)
    }

    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void) {
        base.stopPlayback(completion: completion)
    }

    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        base.fetchArtwork(for: songID, completion: completion)
    }
}

class MusicServiceViewModel: ObservableObject {
    @Published var musicService: AnyMusicService?

    // Other methods and properties specific to your View
    // This ViewModel can also observe changes from the MusicService
}
