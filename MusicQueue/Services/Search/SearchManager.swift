// MARK: - CodeAI Output
/**
 This code demonstrates a SearchManager class that conforms to the SearchManagerProtocol. It provides methods for searching songs and resolving a specific song.
 */

import MusicKit
import os

/**
 A protocol that defines the required methods for a search manager.
 */
protocol SearchManagerProtocol {
    
    /**
     Searches for songs based on the given query.
     
     - Parameters:
        - query: The search query.
        - limit: The maximum number of results to return.
        - completion: A closure that is called when the search is complete. It returns a Result object containing an array of AnyMusicItem objects or an error.
     */
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void)
    
    /**
     Resolves a specific song.
     
     - Parameters:
        - song: The song to resolve.
        - completion: A closure that is called when the resolution is complete. It returns a Result object containing an AnyMusicItem object or an error.
     */
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void)
}

/**
 A concrete implementation of the SearchManagerProtocol.
 */
class SearchManager: SearchManagerProtocol {
    
    let logger = Logger()
    private var _base: SearchManagerProtocol
    private var searchTask: Task<(), Never>? = nil
    let DEBOUNCE_TIME: UInt64 = 200_000_000 // 0.2 seconds
    
    /**
     Initializes a new instance of the SearchManager class with a base implementation of the SearchManagerProtocol.
     
     - Parameter base: The base implementation of the SearchManagerProtocol to use as the underlying search manager.
     */
    init(_ base: SearchManagerProtocol) {
        self._base = base
    }
    
    /**
     Searches for songs based on the given query.
     
     - Parameters:
        - query: The search query.
        - limit: The maximum number of results to return.
        - completion: A closure that is called when the search is complete. It returns a Result object containing an array of AnyMusicItem objects or an error.
     */
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        searchTask?.cancel()
        
        // Debounce the search task to avoid excessive API calls
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
        
        // If the query is empty, return an empty result
        if query.isEmpty {
            return completion(.success([]))
        }
        
        // Call the base implementation to perform the actual search
        self._base.searchSongs(query: query, limit: limit, completion: completion)
    }
    
    /**
     Resolves a specific song.
     
     - Parameters:
        - song: The song to resolve.
        - completion: A closure that is called when the resolution is complete. It returns a Result object containing an AnyMusicItem object or an error.
     */
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        self._base.resolveSong(song: song, completion: completion)
    }
}
