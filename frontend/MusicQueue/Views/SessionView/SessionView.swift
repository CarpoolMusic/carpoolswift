
import SwiftUI

struct SessionView: View {
    
    // MARK: - Properties
    @ObservedObject var sessionViewModel: SessionViewModel
    
    init(sessionManager: SessionManager) {
        self.sessionViewModel = SessionViewModel(sessionManager: sessionManager)
    }
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TitleView(title: "Session View")
                    Button(action: {
                        sessionViewModel.handleSearchButtonPressed()
                    }) {
                        Image(systemName: "search")
                    }
                }
                
                NowPlayingView(currentlyPlayingArt: nil)
                
                Spacer()
                
                AudioControlView(mediaPlayer: sessionViewModel.mediaPlayer, isHost: sessionViewModel.sessionManager.isHost())
                
                Spacer()
                
                MenuBarView(sessionManager: sessionViewModel.sessionManager, sessionViewModel: sessionViewModel)
            }
        }
        .navigationDestination(isPresented: $sessionViewModel.isQueueOpen) {
            QueueView(sessionManager: sessionViewModel.sessionManager)
        }
        .navigationDestination(isPresented: $sessionViewModel.isSearching) {
            SongSearchView()
        }
    }
}

class SessionViewModel: ObservableObject {
    
    @State private var isPlaying = false
    
    @Published var sessionManager: SessionManager
    @Published var mediaPlayer: MediaPlayer
    
    @Published var isQueueOpen = false
    @Published var isSearching = false
    @Published var sessionIsActive: Bool
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionIsActive = sessionManager.isConnected
        let service = UserDefaults.standard.string(forKey: "musicServiceType")
        self.mediaPlayer = MediaPlayer(with: (service == "apple" ? AppleMusicMediaPlayer() : SpotifyMediaPlayer()))
    }
    
    func handleSearchButtonPressed() {
        self.isSearching = true
    }
    
    // MARK: - Loading songs
    /// Loads songs asynchronously.
    private func loadSongs() async throws {
        // Code to load songs
    }
    
    // MARK: - Playback
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        let socketConnection = SocketConnectionHandler()
        let sessionManager = SessionManager()
        
        SessionView(sessionManager: sessionManager)
    }
}
