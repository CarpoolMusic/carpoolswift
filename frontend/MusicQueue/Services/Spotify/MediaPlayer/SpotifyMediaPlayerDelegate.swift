//
//  SpotifyMediaPlayerDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//

extension SpotifyMediaPlayer: SPTAppRemotePlayerStateDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
    }
    
}
