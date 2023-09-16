
import SwiftUI

struct SessionView: View {
    
    // MARK: - Properties
    
    // MARK: - View
    var body: some View {
        VStack {
            HStack {
                Text("Session: \(sessionManager.activeSession?.id ?? "")")
                    .font(.largeTitle)
                    .padding()
            }
            /// now playing section
            VStack {
                Spacer()
                nowPlayingSection
                Spacer()
                
                audioControlSection
                    .padding(.top)
                    .font(.largeTitle)
                
            }
            
            Spacer()
            
            
            /// Lower menu bar,
            HStack {
                // Queue button.
                Button(action: { withAnimation { isQueueOpen.toggle() } }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.largeTitle)
                }
                .padding()
                
                Spacer()
                
                // Chat button.
                Button(action: { /* Handle chat button action */ }) {
                    Image(systemName: "bubble.right")
                        .font(.largeTitle)
                }
                .padding()
                
                Button(action: handleLeaveSessionButtonSelected) {
                    Image(systemName: "arrow.turn.up.left")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .sheet(isPresented: $isQueueOpen) {
                QueueView(sessionManager: sessionManager, musicService: musicService)
            }
        }
        .padding()
        
        // When the view appears, load songs asynchronously.
        .task {
            try? await loadSongs()
        }
    }
    
    
    // MARK: - Now playing view
    @ViewBuilder
    var nowPlayingSection: some View {
        
        @State var uiImage: UIImage? = nil
        
        
    }
    
    // MARK: - Audio control
    var audioControlSection: some View {
        
    }
}

class SessionViewModel: ObservableObject {
    
    @State private var isPlaying = false
    @State private var isQueueOpen = false
    
    // MARK: - Loading songs
    /// Loads songs asynchronously.
    private func loadSongs() async throws {
        // Code to load songs
    }
    
    // MARK: - Playback
    /// The action to perform when the user taps the Leave Session button.
    private func handleLeaveSessionButtonSelected() {
        // Implement session leave logic here
    }
    
    // MARK: - Handlers
    
    
    func handlePlayPauseButtonPressed() {
        // need to pause
        if self.isPlaying {
            musicService.pausePlayback()
        } else {
            Task {
                // otherwise we play
                if (self.sessionManager.currentSong != nil) {
                    await musicService.resumePlayback()
                } else {
                    // Get the next song up and play
                    if let nextSong = self.sessionManager.getNextSong() {
                        do {
                            await musicService.startPlayback(song: nextSong)
                        }
                    }
                }
            }
        }
        self.isPlaying.toggle()
    }
    
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(sessionManager: SessionManager(socketService: SocketService(url: URL(string: "") ?? URL(fileURLWithPath: ""))), musicService: AnyMusicService(SpotifyMusicService()))
    }
}
