//
//  SearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//

import MusicKit

enum SearchError: Error {
    case songNotFound
}

protocol SearchManagerProtocol {
    
    // The search method that takes a query and a completion handler.
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void)
    
    // Takes song information and finds the corresponding song object for service
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void)
    
}

class SearchManager: SearchManagerProtocol {
    
    var _query: String = ""
    private var songs: [AnyMusicItem] = []
    
    private var _base: SearchManagerProtocol
    
    init(_ base: SearchManagerProtocol) {
        self._base = base
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        self._base.searchSongs(query: query, limit: limit, completion: completion)
    }
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        self._base.resolveSong(song: song, completion: completion)
    }    
}
