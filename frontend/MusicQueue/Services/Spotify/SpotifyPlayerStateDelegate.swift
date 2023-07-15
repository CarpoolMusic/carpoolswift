//
//  SpotifyPlayerStateDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-14.
//


class SpotifyPlayerStateDelegate: NSObject, SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("Track name: %@", playerState.track.name)
    }
}
