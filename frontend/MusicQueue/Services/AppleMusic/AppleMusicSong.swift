//
//  AppleMusicSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import SwiftUI
import MusicKit

struct AppleMusicSong: GenericSong {
    private let song: Song

    init(_ song: Song) {
        self.song = song
    }
    
    var id: Int = 0
    var votes: Int = 0
    //    var id: Int {
//        return song.id.rawValue
//    }
    
    var title: String {
        return song.title
    }

    var artist: String {
        return song.artistName
    }

    var album: String {
        return song.albumTitle ?? ""
    }

    var duration: TimeInterval {
        return song.duration ?? 0
    }

    var uri: URL {
        return song.url!
    }
    
    var artworkURL: URL {
        return song.artistURL!
    }
    
    func toJSONData() -> Data? {
        let encoder = JSONEncoder()
        
        let encodableSong = EncodableGenericSong(
            id: self.id,
            votes: self.votes,
            title: self.title,
            artist: self.artist,
            album: self.album,
            duration: self.duration,
            uri: self.uri
        )
        
        return try? encoder.encode(encodableSong)
    }
}
