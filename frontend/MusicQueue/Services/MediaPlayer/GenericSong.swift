//
//  GenericSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import MusicKit

protocol GenericSong: MusicItem, Identifiable, Equatable {
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

enum baseSong {
    case appleSong(MusicKit.Song)
    case spotifySong(SpotifySong)
    case queueEntry(ApplicationMusicPlayer.Queue.Entry)
}

struct AnyMusicItem: GenericSong {
    static func == (lhs: AnyMusicItem, rhs: AnyMusicItem) -> Bool {
        return lhs.title == rhs.title
    }
    
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
    
    private var _base: baseSong
    
    init(_ base: MusicKit.Song) {
        self._base = .appleSong(base)
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
    
    init(_ base: SpotifySong) {
        self._base = .spotifySong(base)
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
    
    func getBase() -> baseSong {
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
