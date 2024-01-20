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
    var uri: String { get }
    var service: String { get }
    var title: String { get }
    var artist: String { get }
    var album: String { get }
    var votes: Int { get }
    
    // Types that are specific to Apple Music Song or Spotify song.
    var artwork: Artwork? { get }
    var artworkURL: String? { get }
}

enum baseSong {
    case appleSong(MusicKit.Song)
    case spotifySong(SpotifySong)
    case queueEntry(ApplicationMusicPlayer.Queue.Entry)
}

struct AnyMusicItem: GenericSong {
    
    var id: String
    var uri: String
    var service: String
    var title: String
    var album: String
    var artist: String
    var votes: Int
    
    var artwork: Artwork?
    var artworkURL: String?
    
    
    private var _base: baseSong
    
    init(_ base: MusicKit.Song) {
        self._base = .appleSong(base)
        
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.id = base.id.rawValue
        self.uri = base.url?.absoluteString ?? ""
        self.title = base.title
        self.artist = base.artistName
        self.album = base.albumTitle ?? ""
        self.artwork = base.artwork
        self.artworkURL = nil
        self.votes = 0
    }
    
    init(_ base: SpotifySong) {
        self._base = .spotifySong(base)
        
        self.service = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
        self.id = base.id
        self.uri = base.uri
        self.title = base.name
        self.artist = base.artists.first ?? ""
        self.album = base.albumName
        self.artwork = nil
        self.artworkURL = base.artworkURL
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
    
    static func == (lhs: AnyMusicItem, rhs: AnyMusicItem) -> Bool {
        return lhs.title == rhs.title
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
