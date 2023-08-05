
import SwiftUI

struct SessionView: View {
    
    // MARK: - Properties
    
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var musicService: AnyMusicService
    
    @State private var isPlaying = false
    
    
    /// Boolean value determining if the queue is being displayed
    @State private var isQueueOpen = false
    
    let albumArtPlaceholder = Image(systemName: "photo")
    
    // MARK: - View
    var body: some View {
        /// Boolean value determining whether user is host or not
        @State var isUserHost = sessionManager.isHost()
        
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
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                    }
                    .disabled(!isUserHost)
                    Button(action: {isPlaying.toggle()}) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                    .disabled(!isUserHost)
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                    }
                    .disabled(!isUserHost)
                }
                .font(.largeTitle)
                .padding(.top)
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
        
        // Get screen dimenesions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        if let currentSong = sessionManager.getNextSong() {
            Group {
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth / 2, height: screenHeight / 2)
                        .clipped()
                } else {
                    ProgressView() // or some placeholder content
                }
            }
            .task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: currentSong.artworkURL)
                    uiImage = UIImage(data: data)
                } catch {
                    // handle error
                    print("Failed to load image from \(String(describing: currentSong.artworkURL)): \(error)")
                }
            }
        } else {
            albumArtPlaceholder
                .resizable()
                .frame(width: screenWidth * 0.85, height: screenHeight * 0.3)
                .clipped()
        }
    }
    
    
    
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
    
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(sessionManager: SessionManager(socketService: SocketService(url: URL(string: "") ?? URL(fileURLWithPath: ""))), musicService: AnyMusicService(SpotifyMusicService()))
    }
}
