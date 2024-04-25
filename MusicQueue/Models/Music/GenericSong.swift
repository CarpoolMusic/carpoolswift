//
//  SongProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import Foundation
import MusicKit
import MediaPlayer
import SwiftUI

protocol SongProtocol {
    var id: String { get }
    var uri: String { get }
    var songTitle: String { get }
    var artist: String { get }
    var albumTitle: String { get }
    var votes: Int { get }
    var artworkURL: String { get }
    var artworkImage: UIImage? {get set}
    
    func artworkImageURL(size: CGSize) -> URL?
    func toSocketSong () -> SocketSong
}

struct SocketSong: Codable {
    
    // Direct properties derived from SpotifyTrack
    var id: String
    var appleId: String?
    var spotifyId: String?
    var uri: String
    var songTitle: String
    var artist: String
    var albumTitle: String
    var votes: Int = 0
    var artworkURL: String
    
    var artworkImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id, appleId, spotifyId, uri, title, artist, album, votes, artworkURL
    }
    
    init(id: String, appleId: String, spotifyId: String, uri: String, songTitle: String, artist: String, albumTitle: String, votes: Int, artworkUrl: String) {
        self.id = id
        self.appleId = appleId
        self.spotifyId = spotifyId
        self.uri = uri
        self.songTitle = songTitle
        self.artist = artist
        self.albumTitle = albumTitle
        self.votes = votes
        self.artworkURL = artworkUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        appleId = try container.decodeIfPresent(String.self, forKey: .appleId)
        spotifyId = try container.decodeIfPresent(String.self, forKey: .spotifyId)
        uri = try container.decode(String.self, forKey: .uri)
        songTitle = try container.decode(String.self, forKey: .title)
        artist = try container.decode(String.self, forKey: .artist)
        albumTitle = try container.decode(String.self, forKey: .album)
        votes = try container.decodeIfPresent(Int.self, forKey: .votes) ?? 0
        artworkURL = try container.decode(String.self, forKey: .artworkURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(appleId, forKey: .appleId)
        try container.encodeIfPresent(spotifyId, forKey: .spotifyId)
        try container.encode(uri, forKey: .uri)
        try container.encode(songTitle, forKey: .title)
        try container.encode(artist, forKey: .album)
        try container.encode(albumTitle, forKey: .album)
        try container.encode(votes, forKey: .votes)
    }
    
    func artworkImageURL(size: CGSize) -> URL? {
        return URL(string: artworkURL)
    }
}

struct AppleSong: SongProtocol {
    let id: String
    let uri: String
    let songTitle: String
    let artist: String
    let albumTitle: String
    var votes: Int
    let musicKitBase: MusicKit.Song
    
    internal let artworkURL: String
    var artworkImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id, appleId, spotifyId, uri, title, artist, album, votes, artworkURL
    }
    
    init(song: MusicKit.Song) {
        self.id = song.id.rawValue
        self.uri = song.url?.absoluteString ?? ""
        self.songTitle = song.title
        self.artist = song.artistName
        self.albumTitle = song.albumTitle ?? ""
        self.votes = 0
        self.artworkURL = song.artwork?.url(width: 300, height: 300)?.absoluteString ?? ""
        self.musicKitBase = song
    }
    
    mutating func upvote() {
        votes += 1
    }
    
    mutating func downvote() {
        votes -= 1
    }
    
    func artworkImageURL(size: CGSize) -> URL? {
        return URL(string: musicKitBase.artwork?.url(width: Int(size.width), height: Int(size.height))?.absoluteString ?? "")
    }
    
    func getMusicKitBase() -> MusicKit.Song {
        return self.musicKitBase
    }
    
    func toSocketSong() -> SocketSong {
        return SocketSong(id: id, appleId: id, spotifyId: "", uri: uri, songTitle: songTitle, artist: artist, albumTitle: albumTitle, votes: votes, artworkUrl: artworkURL)
    }
}

struct SpotifyTrack: Decodable, SongProtocol {
    let id: String
    let uri: String
    let songTitle: String
    let artist: String
    let albumTitle: String
    var votes: Int = 0
    let artworkURL: String
    var artworkImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case uri, id, name, artists, album
        case externalUrls = "external_urls"
        case previewUrl = "preview_url"
    }
    
    enum AlbumKeys: String, CodingKey {
        case name, images
    }
    
    enum ArtistKeys: String, CodingKey {
        case name
    }
    
    enum ImageKeys: String, CodingKey {
        case url, height
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        uri = try container.decode(String.self, forKey: .uri)
        songTitle = try container.decode(String.self, forKey: .name)

        var artistsArray = try container.nestedUnkeyedContainer(forKey: .artists)
        let firstArtistContainer = try artistsArray.nestedContainer(keyedBy: ArtistKeys.self)
        artist = try firstArtistContainer.decode(String.self, forKey: .name)

        let albumContainer = try container.nestedContainer(keyedBy: AlbumKeys.self, forKey: .album)
        albumTitle = try albumContainer.decode(String.self, forKey: .name)
        
        var largestImageUrl: String? = nil
        var largestImageHeight: Int = 0
        
        var imagesArray = try albumContainer.nestedUnkeyedContainer(forKey: .images)
        while !imagesArray.isAtEnd {
            let imageContainer = try imagesArray.nestedContainer(keyedBy: ImageKeys.self)
            let url = try imageContainer.decode(String.self, forKey: .url)
            let height = try imageContainer.decode(Int.self, forKey: .height)
            
            if height > largestImageHeight {
                largestImageHeight = height
                largestImageUrl = url
            }
        }
        
        artworkURL = largestImageUrl ?? ""
    }
    
    func toSocketSong() -> SocketSong {
        return SocketSong(id: id, appleId: "", spotifyId: id, uri: uri, songTitle: songTitle, artist: artist, albumTitle: albumTitle, votes: votes, artworkUrl: artworkURL)
    }
    
    func artworkImageURL(size: CGSize) -> URL? {
        // add logic to choose image based on the size. Spotify returns a small, medium, large URL so choose one of those based on the size passed.
        URL(string: artworkURL)
    }
}
