//
//  Track.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import Foundation

struct SpotifyTrack: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: SpotifyAlbum
    // computed properties
    var artistName: String {artists.first?.name ?? "Unkown Artist"}
    var artworkURL: String {album.images.first?.url ?? "Unkown URL"}
//    let artist: [SpotifyArtist]
    // Add more properties as needed
}

struct Artist: Codable {
    let name: String
}

struct SongImage: Codable {
    let url: String
}

struct SpotifyAlbum: Codable {
    let images: [SongImage]
}


struct TrackResponse: Codable {
    struct TrackItems: Codable {
        let items: [SpotifyTrack]
    }

    let tracks: TrackItems
}
