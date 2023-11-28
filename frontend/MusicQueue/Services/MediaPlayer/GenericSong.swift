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
    func toJSONData() -> Data? {
        // nothing
        return nil
    }
    
    var service: String
    var id: MusicItemID
    var title: String
    var artist: String
    var album: String?
    var duration: TimeInterval?
    var uri: URL?
    var artworkURL: URL?
    var artwork: Artwork?
    var votes: Int
    
    private var _base: (any MusicItem)?
    
    init(_ base: MusicKit.Song) {
        self._base = base
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.id = base.id
        self.title = base.title
        self.artist = base.artistName
        self.album = base.albumTitle
        self.duration = base.duration
        self.uri = base.url
        self.artwork = base.artwork
        self.votes = 0
    }
    
    init(id: String, title: String, artist: String, album: String, votes: Int = 0) {
        self.id = MusicItemID(id)
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.title = title
        self.artist = artist
        self.album = album
        self.votes = votes
    }
        
    init(_ base: any GenericSong) {
        self._base = base
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.id = base.id
        self.title = base.title
        self.artist = base.artist
        self.album = base.album
        self.duration = base.duration
        self.uri = base.uri
        self.artworkURL = base.artworkURL
        self.votes = base.votes
    }

    func getBase() -> (any MusicItem)? {
        return self._base
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
