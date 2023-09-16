//
//  AudioControlView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//

import SwiftUI

struct AudioControlView: View {
    
    let mediaPlayer: MediaPlayer
    let isHost: Bool
    
    init(mediaPlayer: MediaPlayer, isHost: Bool) {
        self.mediaPlayer = mediaPlayer
        self.isHost = isHost
    }
    
    var body: some View {
        return HStack {
            Button(action: {self.mediaPlayer.skipToPrevSong()}) {
                Image(systemName: "backward.fill")
            }
            .disabled(!isHost)
            Button(action: {handlePlayPauseButtonPressed()}) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            .disabled(!isUserHost)
            Button(action: {self.musicService.skipToNextSong()}) {
                Image(systemName: "forward.fill")
            }
            .disabled(!isUserHost)
        }
    }
    
    
}
