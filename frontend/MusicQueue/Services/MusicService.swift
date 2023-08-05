//
//  MusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import Combine
import MusicKit

enum MusicServiceType: String {
    case apple, spotify
}

protocol MusicService: AnyObject {
    
    var searchTerm: String { get set }
    
    var authorizationStatus: MusicServiceAuthStatus { get }
    func authorize()
    func fetchUser() async throws -> User
    func startPlayback(song: CustomSong) async
    func resumePlayback() async
    func pausePlayback()
    func skipToNextSong() async
    func skipToPrevSong() async
    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func requestUpdatedSearchResults(for searchTerm: String)
}

enum MusicServiceError: Error {
    case networkError(Error)
    case authenticationError
    case invalidURL
    case invalidQuery(Error)
    case dataParsingError(Error)
    // other custom error cases...
}
