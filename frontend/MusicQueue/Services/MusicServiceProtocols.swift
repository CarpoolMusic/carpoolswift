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
    case apple, spotify, unselected
}

protocol MusicServiceAuthenticationProtocol: AnyObject {
    /// determines whether the user is currently authenticated with the underlying music service
    var authorizationStatus: MusicServiceAuthStatus { get }
    
    /// authorizes the user with the underlying music service
    func authorize()
}

protocol MusicServicePlayback: AnyObject {
    func startPlayback(song: CustomSong) async
    func resumePlayback() async
    func pausePlayback()
    func skipToNextSong()
    func skipToPrevSong()
}

protocol MusicServiceMediaController: AnyObject {
    var searchTerm: String { get set }
    func requestUpdatedSearchResults(for searchTerm: String)
    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

enum MusicServiceError: Error {
    case networkError(Error)
    case authenticationError
    case invalidURL
    case invalidQuery(Error)
    case dataParsingError(Error)
    // other custom error cases...
}
