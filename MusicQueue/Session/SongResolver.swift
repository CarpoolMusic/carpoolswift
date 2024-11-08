import SwiftUI
import Foundation
import MusicKit
import SDWebImage

/** 
 Theres 3 main types of resolutions associated with songs:
 1) Artwork resolution: This is just resolving the artwork image using the URL that is passed.
 2) MusicKit song: The apple media player uses MusicKit.Song. This resolves a MusicItemID into a MusicKit.Song as a preprocessing for the media player.
 3) Resolving to other song type. There will be cases where we are broadcast some song type but need another. This resolves the broadcasted song into the desired type.
 **/



class SongResolver {
    @Injected private var logger: CustomLoggerProtocol
    private let defaultArtwork = UIImage(named: "AlbumArtPlaceholder")!
    
    private let appleSearchManager = AppleMusicSearchManager()
    private let spotifySearchManager = SpotifySearchManager()
    
    func prefetchArtwork(for artworkURL: URL?) {
        guard let url = artworkURL else {
            return
        }
        SDWebImagePrefetcher.shared.prefetchURLs([url])
    }
    
    func resolveMusicKitSong(for songId: MusicItemID) async throws -> MusicKit.Song {
        let request = MusicCatalogResourceRequest<MusicKit.Song>(matching: \.id, equalTo: songId)
        let response = try await request.response()
        guard let song = response.items.first else {
            throw SongResolutionError(message: "No song was found with the specificed ID.")
        }
        
        return song
    }
    
    func resolveAppleSongToSpotifyTrack(song: SongProtocol) async throws -> SongProtocol? {
        return try await spotifySearchManager.resolveSong(song: song)
        
    }
    
    func resolveSpotifyTrackToAppleSong(song: SongProtocol) async throws -> SongProtocol? {
        return try await appleSearchManager.resolveSong(song: song)
    }
}
