import SwiftUI

struct AudioControlView: View {
    @EnvironmentObject private var mediaPlayer: MediaPlayer
    
    @State var currentTrackTime: Double = 45.0
    @State var isPlaying: Bool = false
    @State var isHost: Bool = false
    
    init(isHost: Bool) {
        self.isHost = isHost
    }

    var body: some View {
        VStack {
            Text("Now Playing")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Text("Current Song")
                .font(.headline)
                .padding(1)

            Text("Artist")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)

            Slider(value: $currentTrackTime, in: 0...100)
                .accentColor(.purple)
                .padding(.horizontal)

            HStack {
                PlaybackButton(systemImageName: "backward.fill", action: {
                    previousTrack()
                }, buttonSize: 50, backgroundColors: [Color.blue, Color.purple], cornerRadius: 25)
                .disabled(!isHost)
                .opacity(isHost ? 1.0 : 0.5)
                
                Spacer()

                PlaybackButton(systemImageName: mediaPlayer.isPlaying() ? "pause.fill" : "play.fill", action: {
                    togglePlayPause()
                }, buttonSize: 60, backgroundColors: [Color.green, Color.blue], cornerRadius: 30)
                .disabled(!isHost)
                .opacity(isHost ? 1.0 : 0.5)
                
                Spacer()

                PlaybackButton(systemImageName: "forward.fill", action: {
                    nextTrack()
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

    func togglePlayPause() {
        mediaPlayer.togglePlayPause()
        isPlaying = mediaPlayer.isPlaying()
    }

    func previousTrack() {
        mediaPlayer.skipToPrevious()
    }

    func nextTrack() {
        mediaPlayer.skipToNext()
    }
}

// Assuming MockMediaPlayer and MockSongQueue are placeholder types for the preview
struct AudioControlView_Previews: PreviewProvider {
    static var previews: some View {
        AudioControlView(isHost: true)
            .environmentObject(MockMediaPlayer(queue: MockSongQueue()))
    }
}
