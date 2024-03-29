/**
 This class is an implementation of the `SearchManagerProtocol` protocol and provides methods for searching and resolving songs using the Apple Music API.
 */

import Foundation
import MusicKit
import os

class AppleMusicSearchManager: SearchManagerProtocol {
    let logger = Logger()
    
    var _query: String = ""
    private var songs: [AnyMusicItem] = []
    
    /**
     Resolves a song by its `Song` object.
     
     - Parameters:
        - song: The `Song` object to resolve.
        - completion: A closure that is called when the resolution is complete. It takes a `Result<AnyMusicItem, Error>` parameter, where `AnyMusicItem` represents the resolved song or an error if the resolution fails.
     */
    func resolveSong(song: Song, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        resolveSongById(id: MusicItemID(song.appleID), completion: completion)
    }
    
    /**
     Resolves a song by its ID.
     
     - Parameters:
        - id: The ID of the song to resolve.
        - completion: A closure that is called when the resolution is complete. It takes a `Result<AnyMusicItem, Error>` parameter, where `AnyMusicItem` represents the resolved song or an error if the resolution fails.
     */
    private func resolveSongById(id: MusicItemID, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        Task {
            do {
                let searchRequest = MusicCatalogResourceRequest<MusicKit.Song>(matching: \.id, equalTo: id)
                let searchResponse = try await searchRequest.response()
                
                guard let matchingSong = searchResponse.items.first.map({ AnyMusicItem($0) }) else {
                    throw SongResolutionError(message: "Unable to resolve song with id \(id)", stacktrace: Thread.callStackSymbols)
                }
                completion(.success(matchingSong))
            } catch let error as SongResolutionError {
                logger.log(level: .error, "\(error.toString())")
                completion(.failure(error))
            } catch {
                logger.log(level: .error, "\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    /**
     Searches for songs based on a query string and limit.
     
     - Parameters:
        - query: The query string to search for.
        - limit: The maximum number of songs to retrieve.
        - completion: A closure that is called when the search is complete. It takes a `Result<[AnyMusicItem], Error>` parameter, where `[AnyMusicItem]` represents the list of matching songs or an error if the search fails.
     */
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        
        self._query = query
        
        Task {
            do {
                print("Query inside", self._query)
                var searchRequest = MusicCatalogSearchRequest(term: self._query, types: [MusicKit.Song.self])
                searchRequest.limit = limit
                searchRequest.includeTopResults = true
                let searchResponse = try await searchRequest.response()
                
                await apply(searchResponse, for: self._query)
                completion(.success(songs))
            } catch {
                logger.log(level: .error, "Search request failed with error \(error)")
                await reset()
                completion(.failure(error))
            }
        }
    }
    
    /**
     Applies the search response to the current query.
     
     - Parameters:
        - searchResponse: The `MusicCatalogSearchResponse` object containing the search results.
        - searchTerm: The original query string used for the search.
     */
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if _query == searchTerm {
            songs = searchResponse.songs.compactMap { AnyMusicItem($0) }
        }
    }
    
    /**
     Resets the list of songs to an empty array.
     */
    @MainActor
    private func reset() {
        songs = []
    }
}
