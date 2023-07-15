//
//  MusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

protocol MusicService {
    var authorizationStatus: MusicServiceAuthStatus { get }
    func authorize(completion: @escaping (Result<User, Error>) -> Void)
    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void)
    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    // Other methods as needed...
}
