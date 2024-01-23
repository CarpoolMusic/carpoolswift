//
//  AppleMusicSearchManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-05.
//

import MusicKit
import os

class AppleMusicSearchManager: SearchManagerProtocol {
    let logger = Logger()
    
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
    
    func resolveSong(query: String, completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        Task {
            do {
                var searchRequest = MusicCatalogSearchRequest(term: query, types: [MusicKit.Song.self])
                searchRequest.limit = 1
                let searchResponse = try await searchRequest.response()
                
                guard let matchingSong = searchResponse.songs.first.map({ AnyMusicItem($0) }) else {
                    throw SongResolutionError(message: "Unable to resolve song with query \(query)", stacktrace: Thread.callStackSymbols)
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
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        self._query = query
        
        Task {
            guard !self._query.isEmpty else {
                await self.reset()
                completion(.success([]))
                return
            }
            
            do {
                var searchRequest = MusicCatalogSearchRequest(term: self._query, types: [MusicKit.Song.self])
                searchRequest.limit = limit
                searchRequest.includeTopResults = true
                let searchResponse = try await searchRequest.response()
                
                await self.apply(searchResponse, for: self._query)
                completion(.success(songs))
            } catch {
                logger.log(level: .error, "Search request failed with error \(error)")
                await self.reset()
                completion(.failure(error))
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
