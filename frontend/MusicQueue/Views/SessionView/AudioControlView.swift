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
            Button(action: {
                self.mediaPlayer.performMediaPlayerAction(mediaPlayer.skipToPrevious)
                
            }) {
                Image(systemName: "backward.fill")
            }
            .disabled(!isHost)
            Button(action: {
                self.mediaPlayer.performMediaPlayerAction(mediaPlayer.togglePlayPause)
                
            }) {
                Image(systemName: mediaPlayer.isPlaying() ? "pause.fill" : "play.fill")
            }
            .disabled(!isHost)
            Button(action: {
                self.mediaPlayer.performMediaPlayerAction(self.mediaPlayer.skipToNext)
                
            }) {
                Image(systemName: "forward.fill")
            }
            .disabled(!isHost)
        }
    }
    
    
}
