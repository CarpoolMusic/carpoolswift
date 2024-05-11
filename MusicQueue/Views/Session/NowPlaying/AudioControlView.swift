import SwiftUI
import Combine

struct AudioControlView: View {
    @ObservedObject private var mediaPlayer: MediaPlayer
    
    @EnvironmentObject private var session: Session
    
    @State var isHost: Bool = true
    
    @State private var cancellables = Set<AnyCancellable>()
    
    // Subscribed variables
    @State private var currentSong: (SongProtocol)?
    
    init(isHost: Bool) {
        self.mediaPlayer = MediaPlayer()
        self.isHost = isHost
    }
    
    var body: some View {
        VStack {
            Text(currentSong?.songTitle ?? "")
                .font(.headline)
                .padding(1)
            
            Text(currentSong?.artist ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            Text(currentSong?.albumTitle ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            Slider(
                value: Binding(
                    get: { self.mediaPlayer.displayTime / ((currentSong?.duration ?? 1) / 1000) },
                    set: { newValue in
                        self.mediaPlayer.displayTime = newValue
                        let duration = currentSong?.duration ?? 0
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
        .onAppear {
            // Subscribe when the view appears
            setupSubscriptions()
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Adjusts for dark/light mode
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    
    private func setupSubscriptions() {
        session.queue.$currentSong
            .receive(on: RunLoop.main)
            .sink { newSong in
                self.currentSong = newSong
            }
            .store(in: &cancellables)
    }
}

// Assuming MockMediaPlayer and MockSongQueue are placeholder types for the preview
struct AudioControlView_Previews: PreviewProvider {
    static var previews: some View {
        AudioControlView(isHost: true)
            .environmentObject(MockMediaPlayer())
    }
}

