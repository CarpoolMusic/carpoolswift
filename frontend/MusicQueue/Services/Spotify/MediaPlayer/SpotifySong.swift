//
//  SpotifySong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//
import Foundation

struct SpotifySong: GenericSong {
    
//    var id: String = UUID().uuidString
    var id: Int = 0
    

    private let track: SPTAppRemoteTrack

    init(_ track: SPTAppRemoteTrack) {
        self.track = track
    }
    
    var title: String {
        return track.name
    }

    var artist: String {
        return track.artist.name // adjust this according to the actual property
    }

    var album: String {
        return track.album.name // adjust this according to the actual property
    }

    var duration: TimeInterval {
        return TimeInterval(track.duration)
    }

    var uri: URL {
        return URL(string: track.uri)!
    }
    
    var artworkURL: URL {
        return URL(string: "")!
    }
    
    var votes: Int = 0
}
