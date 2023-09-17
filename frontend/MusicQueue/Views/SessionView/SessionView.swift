
import SwiftUI

struct SessionView: View {
    
    // MARK: - Properties
    private var sessionManager: SessionManager
    private var mediaPlayer: MediaPlayer
    @ObservedObject var sessionViewModel: SessionViewModel
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        sessionViewModel = SessionViewModel(sessionManager: sessionManager)
    }
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                TitleView(title: "Session View")
                NowPlayingView(currentlyPlayingArt: nil)
                
                Spacer()
                
                AudioControlView(mediaPlayer: mediaPlayer, isHost: sessionManager.isHost())
                
                Spacer()
                
                MenuBarView(sessionManager: sessionManager, sessionViewModel: sessionViewModel)
            }
        }
        .navigationDestination(isPresented: $sessionViewModel.isQueueOpen) {
            QueueView(sessionManager: sessionManager)
        }
    }
}

class SessionViewModel: ObservableObject {
    
    @State private var isPlaying = false
    
    @Published var isQueueOpen = false
    @Published var sessionIsActive: Binding<Bool>
    
    init(sessionManager: SessionManager) {
        self.sessionIsActive = sessionIsActive
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
        let socketConnection = SocketConnectionHandler(url: URL(string: "")!)
        let sessionManager = SessionManager(socketConnectionHandler: socketConnection)
        
        SessionView(sessionManager: sessionManager)
    }
}
