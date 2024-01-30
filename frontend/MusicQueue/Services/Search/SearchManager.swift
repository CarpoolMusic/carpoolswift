//
//  SearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//

import MusicKit
import os

protocol SearchManagerProtocol {
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void)
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void)
}

class SearchManager: SearchManagerProtocol {
    let logger = Logger()
    
    private var _base: SearchManagerProtocol
    private var searchTask: Task<(), Never>? = nil
    
    let DEBOUNCE_TIME: UInt64 = 200_000_000 // 0.2 seconds
    
    init(_ base: SearchManagerProtocol) {
        self._base = base
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        // Cancel previous task if it exists to avoid unecessary calls
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                try await Task.sleep(nanoseconds: DEBOUNCE_TIME)
                guard !Task.isCancelled else {
                    throw SearchError(message: "Task has been cancelled", stacktrace: Thread.callStackSymbols)
                }
            } catch let error {
                logger.log(level: .error, "Failed to search song with error \(error)")
            }
        }
        
        if query.isEmpty {
            return completion(.success([]))
        }
        
        self._base.searchSongs(query: query, limit: limit, completion: completion)
    }
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        self._base.resolveSong(song: song, completion: completion)
    }    
}
