//
//  SpotifySong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//

struct SpotifySong: GenericSong {
    
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

    var uri: String {
        return track.uri
    }
}
