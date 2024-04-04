import os
import Foundation
import UIKit
import Kingfisher

class SpotifySearchManager: SearchManagerProtocol {
    @Injected private var logger: CustomLogger
    
    let spotifyAPIClient: SpotifyAPIClient
    
    init() {
        spotifyAPIClient = SpotifyAPIClient()
    }
    
    // Function to search songs based on a query and limit
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        spotifyAPIClient.searchSongs(query: query, limit: limit, completion: completion)
    }
    
    // Function to resolve a specific song and its artwork
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        var song = SpotifySong(song: song)
        
        // Resolving the artwork for the song
        resolveArtwork(artworkURL: song.artworkURL) { image in
            guard let image = image else {
                print("Unable to resolve artwork")
                return
            }
            song.artworkImage = image
            completion(.success(AnyMusicItem(song)))
        }
    }
    
    // Private function to resolve the artwork for a given URL
    private func resolveArtwork(artworkURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: artworkURL) else {
            completion(nil)
            return
        }
        
        // Using Kingfisher library to retrieve the image from the URL
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
