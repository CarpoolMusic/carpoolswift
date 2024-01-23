//
//  SpotifySearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//
import os

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
        print("resovle song \(song)")
        let song = SpotifySong(song: song)
        completion(.success(AnyMusicItem(song)))
    }
}
