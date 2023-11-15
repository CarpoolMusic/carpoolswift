//
//  AppleMusicSearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//

import MusicKit

class AppleMusicSearchManager: SearchManagerProtocol {
    
    var _query: String = ""
    private var songs: [AnyMusicItem] = []
    
    func searchSongs(query: String, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        self._query = query
        Task {
            if self._query.isEmpty {
                await self.reset()
                completion(.success([]))
            } else {
                do {
                    // Issue a catalog search request for albums matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: self._query, types: [Song.self])
                    searchRequest.limit = 10
                    searchRequest.includeTopResults = true
                    let searchResponse = try await searchRequest.response()
                    completion(.success(songs))
                    
                    // Update the user interface with the search response.
                    await self.apply(searchResponse, for: self._query)
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                }
            }
        }
    }
    /// Safely updates the `songs` property on the main thread.
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self._query == searchTerm {
            let songs = searchResponse.songs.compactMap {
                song in AnyMusicItem(song)
            }
            self.songs = songs
        }
    }
    
    /// Safely resets the `songs` property on the main thread.
    @MainActor
    private func reset() {
        self.songs = []
    }
}
