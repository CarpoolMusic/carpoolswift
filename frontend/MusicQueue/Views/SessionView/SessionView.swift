
import SwiftUI
import Combine

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
                    TitleView(title: "TESTESTST")
                    
                    Spacer()
                    
                    ButtonImageView(action: sessionViewModel.handleSearchButtonPressed, buttonImage: Image(systemName: "magnifyingglass"))
                }
                
                NowPlayingView(mediaPlayer: sessionViewModel.mediaPlayer)
                
                Spacer()
                
                AudioControlView(mediaPlayer: sessionViewModel.mediaPlayer, isHost: sessionViewModel.sessionManager.isHost())
                
                Spacer()
                
                MenuBarView(sessionManager: sessionViewModel.sessionManager, sessionViewModel: sessionViewModel)
            }
            .sheet(isPresented: $sessionViewModel.isQueueOpen) {
                QueueView(sessionManager: sessionViewModel.sessionManager)
            }
            .sheet(isPresented: $sessionViewModel.isSearching) {
                SongSearchView(sessionManager: sessionViewModel.sessionManager)
            }
            
        }
    }
}

class SessionViewModel: ObservableObject {
    
    @Published private var isPlaying = false
    
    @Published var sessionManager: SessionManager
    @Published var mediaPlayer: MediaPlayer
    
    @Published var isQueueOpen = false
    @Published var isSearching = false
    @Published var sessionIsActive: Bool
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionIsActive = sessionManager.isConnected
        let service = UserDefaults.standard.string(forKey: "musicServiceType")
        self.mediaPlayer = MediaPlayer(queue: sessionManager.queue)
        
        // subscribe to changes in queue
//        sessionManager.$queueUpdated
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                // Update queue in media player
//                self?.mediaPlayer.setQueue(queue: self?.sessionManager.queue ?? Queue())
//            }
//            .store(in: &cancellables)
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
