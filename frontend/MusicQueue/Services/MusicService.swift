//
//  MusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import Combine

enum MusicServiceType: String {
    case apple, spotify
}

protocol MusicService {
    var authorizationStatus: MusicServiceAuthStatus { get }
    func authorize()
    func fetchUser() async throws -> User
    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void)
    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func searchSongs(query: String) -> AnyPublisher<[Song], Error>
}

enum MusicServiceError: Error {
    case networkError(Error)
    case authenticationError
    case invalidURL
    case invalidQuery(Error)
    case dataParsingError(Error)
    // other custom error cases...
}
