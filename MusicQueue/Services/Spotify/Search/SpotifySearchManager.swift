import SwiftUI
import os
import Foundation

class SpotifySearchManager: SearchManagerBaseProtocol {
    @Injected private var logger: CustomLoggerProtocol
    
    let spotifyAPIClient: SpotifyAPIClient
    
    init() {
        spotifyAPIClient = SpotifyAPIClient()
    }
    
    func searchSongs(query: String, limit: Int) async throws -> [SongProtocol] {
        logger.debug("Using query \(query)")
        return try await spotifyAPIClient.searchSongs(query: query, limit: limit)
    }
    
    func resolveSong(song: SongProtocol) async throws -> SongProtocol? {
        return try await spotifyAPIClient.resolveSong(song: song)
        
    }
}
