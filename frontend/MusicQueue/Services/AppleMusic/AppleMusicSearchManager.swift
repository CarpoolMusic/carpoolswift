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
    
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        var query = song.id
        
        if song.service == MusicServiceType.apple.rawValue {
            let id = MusicItemID(song.id)
            resolveSongById(id: id, completion: completion)
        } else if (false) {
            // TODO: Check cache to see if we have a mapping to the correct service type
        } else {
            // Otherwise search by query
            query = song.title + " " + song.artist + " " + song.album
            resolveSong(query: query, completion: completion)
        }
    }
            
    private func resolveSongById(id: MusicItemID, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        Task {
            do {
                let searchRequest = MusicCatalogResourceRequest<MusicKit.Song>(matching: \.id, equalTo: id)
                let searchResponse = try await searchRequest.response()
                
                if let matchingSong = searchResponse.items.first.map({ AnyMusicItem($0) }) {
                    completion(.success(matchingSong))
                } else {
                    completion(.failure(SearchError.songNotFound))
                }
            }
        }
        
    }
    
    func resolveSong(query: String, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        Task {
            do {
                var searchRequest = MusicCatalogSearchRequest(term: query, types: [MusicKit.Song.self])
                searchRequest.limit = 1
                let searchResponse = try await searchRequest.response()
                
                if let matchingSong = searchResponse.songs.first.map({ AnyMusicItem($0) }) {
                    // TODO: Put the mapping in the cache for next time
            
                    completion(.success(matchingSong))
                } else {
                    completion(.failure(SearchError.songNotFound))
                }
            } catch {
                print("Search request failed with error: \(error).")
                completion(.failure(error))
            }
        }
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        self._query = query
        Task {
            if self._query.isEmpty {
                await self.reset()
                completion(.success([]))
            } else {
                do {
                    // Issue a catalog search request for songs matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: self._query, types: [MusicKit.Song.self])
                    searchRequest.limit = limit
                    searchRequest.includeTopResults = true
                    let searchResponse = try await searchRequest.response()
                    
                    // Update the songs list with the search results
                    await self.apply(searchResponse, for: self._query)
                    completion(.success(songs))
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                }
            }
        }
    }
    
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self._query == searchTerm {
            let songs = searchResponse.songs.compactMap {
                song in AnyMusicItem(song)
            }
            self.songs = songs
        }
    }
    
    @MainActor
    private func reset() {
        self.songs = []
    }
}
