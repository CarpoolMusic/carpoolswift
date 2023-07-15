//
//  MusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

enum MusicServiceType: String {
    case apple, spotify
}

protocol MusicService {
    var authorizationStatus: MusicServiceAuthStatus { get }
    func authorize()
    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void)
    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    // Other methods as needed...
}
