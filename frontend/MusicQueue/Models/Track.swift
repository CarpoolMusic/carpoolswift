//
//  Track.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import Foundation

struct Track: Codable {
    let id: String
    let name: String
    let artists: [SpotifyArtist]
    // Add more properties as needed
}

struct TrackResponse: Codable {
    struct TrackItems: Codable {
        let items: [Track]
    }

    let tracks: TrackItems
}
