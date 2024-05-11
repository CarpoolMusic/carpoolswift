//
//  Media.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-17.
//

import Foundation

struct SpotifySearchResponse: Decodable {
    let tracks: SpotifyTracksResult
}

struct SpotifyTracksResult: Decodable {
    let items: [SpotifyTrack]
}

//struct SpotifyTrack: Decodable {
//    let id: String
//    let uri: String
//    let name: String
//    let artists: [SpotifyArtist]
//    let album: SpotifyAlbum
//    let externalUrls: [String: String]
//    let previewUrl: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id, uri, name, artists, album
//        case externalUrls = "external_urls"
//        case previewUrl = "preview_url"
//    }
//}

struct SpotifyArtist: Decodable {
    let id: String
    let name: String
    let externalUrls: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case externalUrls = "external_urls"
    }
}

struct SpotifyAlbum: Decodable {
    let id: String
    let name: String
    let artists: [SpotifyArtist]
    let images: [SpotifyImage]
    let externalUrls: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, images
        case externalUrls = "external_urls"
    }
}

struct SpotifyImage: Decodable {
    let url: String
    let height: Int
    let width: Int
}
