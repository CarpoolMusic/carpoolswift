import SwiftUI
import Combine

struct AudioControlView: View {
    @EnvironmentObject private var session: Session
    @EnvironmentObject private var mediaPlayer: MediaPlayer
    
    @State var isHost: Bool = true
    
    init(isHost: Bool) {
        self.isHost = isHost
    }
    
    var body: some View {
        VStack {
            Text(session.queue.currentSong?.songTitle ?? "")
                .font(.headline)
                .padding(1)
            
            Text(session.queue.currentSong?.artist ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            Text(session.queue.currentSong?.albumTitle ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            Slider(
                value: Binding(
                    get: { self.mediaPlayer.displayTime / ((session.queue.currentSong?.duration ?? 1) / 1000) },
                    set: { newValue in
                        self.mediaPlayer.displayTime = newValue
                        let duration = session.queue.currentSong?.duration ?? 0
                        self.mediaPlayer.scrubState = .scrubEnded(newValue * (duration / 1000))
                    }
                ),
                in: 0...1,
                onEditingChanged: { editing in
                    if editing {
                        self.mediaPlayer.scrubState = .scrubStarted
                    } else {
                        self.mediaPlayer.scrubState = .scrubEnded(self.mediaPlayer.displayTime)
                    }
                }
            )
            .accentColor(.purple)
            .padding(.horizontal)
            
            HStack {
                PlaybackButton(systemImageName: "backward.fill", action: {
                    mediaPlayer.skipToPrevious()
                }, buttonSize: 50, backgroundColors: [Color.blue, Color.purple], cornerRadius: 25)
                .disabled(!isHost)
                .opacity(isHost ? 1.0 : 0.5)
                
                Spacer()
                
                PlaybackButton(systemImageName: (mediaPlayer.playerState == .playing) ? "pause.fill" : "play.fill", action: {
                    mediaPlayer.togglePlayPause()
                }, buttonSize: 60, backgroundColors: [Color.green, Color.blue], cornerRadius: 30)
                .disabled(!isHost)
                .opacity(isHost ? 1.0 : 0.5)
                
                Spacer()
                
                PlaybackButton(systemImageName: "forward.fill", action: {
                    mediaPlayer.skipToNext()
                }, buttonSize: 50, backgroundColors: [Color.purple, Color.red], cornerRadius: 25)
                .disabled(!isHost)
                .opacity(isHost ? 1.0 : 0.5)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Adjusts for dark/light mode
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

// Assuming MockMediaPlayer and MockSongQueue are placeholder types for the preview
//struct AudioControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioControlView(isHost: true)
//            .environmentObject(MockMediaPlayer())
//    }
//}

