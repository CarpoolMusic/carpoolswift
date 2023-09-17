//
//  AppleMusicSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import MusicKit

struct AppleMusicSong: GenericSong {
    private let song: Song

    init(_ song: Song) {
        self.song = song
    }

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

    var uri: String {
        return song.id.rawValue
    }
    
    var artwork: UIImage {
        return UImage(url: song.artwork.url)
    }
}
