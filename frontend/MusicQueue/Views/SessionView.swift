
import SwiftUI

struct SessionView: View {
    
    // MARK: - Properties
    
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var musicService: AnyMusicService
    
    /// Boolean value determining whether user is host or not
    @State private var isUserHost = true // placeholder
    
    /// Boolean value determining if the queue is being displayed
    @State private var isQueueOpen = false
    
    let albumArtPlaceholder = Image(systemName: "photo")
    
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
                albumArtPlaceholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                    }
                    .disabled(!isUserHost)
                    Button(action: {}) {
                        Image(systemName: "playpause.fill")
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
