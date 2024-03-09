//
//  AudioControlView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//

import SwiftUI

struct AudioControlView: View {
    
    @State var currentTrackTime: Double = 45.0
    @State var isPlaying: Bool = false
    
    let mediaPlayer: MediaPlayer
    let isHost: Bool
    
    init(mediaPlayer: MediaPlayer, isHost: Bool) {
        self.mediaPlayer = mediaPlayer
//        self.isHost = isHost
        self.isHost = true
    }
    
    var body: some View {
        VStack {
            
            Text("Current Song")
                .font(.headline)
            Text("Artist")
                .font(.subheadline)
            
            Slider(value: $currentTrackTime, in: 0...100)
                .accentColor(.purple)
                .padding()
            
            HStack {
                Button(action: previousTrack) {
                    Image(systemName: "backward.fill")
                }
                .disabled(!isHost)
                .buttonStyle(PlaybackButtonStyle())
                .padding()
                
                Button(action: togglePlayPause) {
                    Image(systemName: mediaPlayer.isPlaying() ? "pause.fill" : "play.fill")
                }
                .disabled(!isHost)
                .buttonStyle(PlaybackButtonStyle())
                .padding()
                
                Button(action: nextTrack) {
                    Image(systemName: "forward.fill")
                }
                .disabled(!isHost)
                .buttonStyle(PlaybackButtonStyle())
                .padding()
            }
        }
        .animation(.easeInOut, value: isPlaying)
    }
    
    func togglePlayPause() {
        self.mediaPlayer.togglePlayPause()
        self.isPlaying = !isPlaying
    }

    func previousTrack() {
        self.mediaPlayer.skipToPrevious()
    }

    func nextTrack() {
        self.mediaPlayer.skipToNext()
    }
    
    
}

// Preview Provider for AudioControlView
struct AudioControlView_Previews: PreviewProvider {
    static var previews: some View {
        // Use the mock MediaPlayer instance here
        AudioControlView(mediaPlayer: MockMediaPlayer(queue: MockSongQueue()), isHost: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
