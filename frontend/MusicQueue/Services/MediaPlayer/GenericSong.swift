//
//  GenericSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import MusicKit

protocol GenericSong: MusicItem, Identifiable {
    var id: MusicItemID { get }
    var title: String { get }
    var artist: String { get }
    var album: String? { get }
    var duration: TimeInterval? { get }
    var uri: URL? { get }
    var artworkURL: URL? { get }
    var artwork: Artwork? { get set }
    var votes: Int { get }
    func toJSONData() -> Data?
}

struct AnyMusicItem: GenericSong {
    var id: MusicItemID
    var title: String
    var artist: String
    var album: String?
    var duration: TimeInterval?
    var uri: URL?
    var artworkURL: URL?
    var artwork: Artwork?
    var votes: Int
    
    private var _base: any MusicItem
    
    init(_ base: Song) {
        self._base = base
        self.id = base.id
        self.title = base.title
        self.artist = base.artistName
        self.album = base.albumTitle
        self.duration = base.duration
        self.uri = base.url
        self.artwork = base.artwork
        self.votes = 0
    }
    
    init(_ base: any GenericSong) {
        self._base = base
        self.id = base.id
        self.title = base.title
        self.artist = base.artist
        self.album = base.album
        self.duration = base.duration
        self.uri = base.uri
        self.artworkURL = base.artworkURL
        self.votes = base.votes
    }
    
    func toJSONData() -> Data? {
        // impl
        return nil
    }
}

// Inner struct to convert only the properties we need
struct EncodableGenericSong: Codable {
    var id: String
    var votes: Int
    var title: String
    var artist: String
    var album: String
    var duration: TimeInterval
    var uri: URL
}
