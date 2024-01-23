//
//  SearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//

import MusicKit

protocol SearchManagerProtocol {
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void)
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void)
}

class SearchManager: SearchManagerProtocol {
    
    private var _base: SearchManagerProtocol
    
    init(_ base: SearchManagerProtocol) {
        self._base = base
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        if query.isEmpty {
            return
        }
        self._base.searchSongs(query: query, limit: limit, completion: completion)
    }
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        self._base.resolveSong(song: song, completion: completion)
    }    
}
