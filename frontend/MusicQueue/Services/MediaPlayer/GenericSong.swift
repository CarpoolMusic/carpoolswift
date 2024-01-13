//
//  GenericSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import Foundation
import MusicKit

protocol GenericSong: Identifiable, Equatable {
    var id: String { get }
    var title: String { get }
    var artist: String { get }
    var album: String? { get }
    var duration: TimeInterval? { get }
    var uri: String { get }
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
    var id: String
    var uri: String
    var title: String
    var artist: String
    var album: String?
    var duration: TimeInterval?
    var artworkURL: URL?
    var artwork: Artwork?
    var artworkImage: UIImage?
    var votes: Int
    
    private var _base: baseSong
    
    init(_ base: MusicKit.Song) {
        self._base = .appleSong(base)
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.id = base.id.rawValue
        self.title = base.title
        self.artist = base.artistName
        self.album = base.albumTitle
        self.duration = base.duration
        self.uri = base.url?.absoluteString ?? ""
        self.votes = 0
    }
    
    init(_ base: SpotifySong) {
        self._base = .spotifySong(base)
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.id = base.id
        self.title = base.name
        self.artist = base.artists.first ?? ""
        self.album = base.albumName
        self.duration = TimeInterval(base.duration)
        self.uri = base.uri
        self.artworkURL = URL(string: base.image)
        self.votes = 0
    }
    
    func getBase() -> baseSong {
        return self._base
    }
    
    mutating func upvote() {
        self.votes += 1
    }
    
    mutating func downvote() {
        self.votes -= 1
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
