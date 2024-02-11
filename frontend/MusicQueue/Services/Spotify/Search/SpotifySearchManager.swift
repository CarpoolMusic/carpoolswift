//
//  SpotifySearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//
import os
import Foundation
import UIKit

import Kingfisher

class SpotifySearchManager: SearchManagerProtocol {
    let logger = Logger()
   
    let _spotifyAPIClient: SpotifyAPIClient
    
    init() {
        _spotifyAPIClient = SpotifyAPIClient()
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        _spotifyAPIClient.searchSongs(query: query, limit: limit, completion: completion)
    }
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        var song = SpotifySong(song: song)
        
        resolveArtwork(artworkURL: song.artworkURL) { image in
            guard let image else {
                print("Unable to resolve artwork ")
                return
            }
            song.artworkImage = image
            completion(.success(AnyMusicItem(song)))
        }
    }
    
    private func resolveArtwork(artworkURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: artworkURL) else {
            completion(nil)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(_):
                print("Failed to resolve image")
                completion(nil)
            }
        }
    }
}
