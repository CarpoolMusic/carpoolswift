//
//  SearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//

import MusicKit

protocol SearchManagerProtocol {
    
    // The search method that takes a query and a completion handler.
    func searchSongs(query: String, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void)
}

class SearchManager: SearchManagerProtocol {
    
    var _query: String = ""
    private var songs: [AnyMusicItem] = []
    
    private var _base: SearchManagerProtocol
    
    init(_ base: SearchManagerProtocol) {
        self._base = base
    }
    
    func searchSongs(query: String, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        self._base.searchSongs(query: query, completion: completion)
    }
}
