// MARK: - CodeAI Output
/**
 This code represents the view for a session in an app. It displays various components such as a title, now playing information, audio controls, and a menu bar. It also includes functionality for handling button presses and managing the session.
 */

import SwiftUI
import Combine

struct SessionView: View {
    
    @ObservedObject var sessionViewModel: SessionViewModel
    
    init(sessionManager: SessionManager) {
        self.sessionViewModel = SessionViewModel(sessionManager: sessionManager)
    }
    
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

/**
 This class represents the view model for a session. It manages the state and functionality of the view.
 */

class SessionViewModel: ObservableObject {
    
    @Published private var isPlaying = false
    @Published var sessionManager: SessionManager
    @Published var mediaPlayer: MediaPlayer
    @Published var isQueueOpen = false
    @Published var isSearching = false
    @Published var sessionIsActive = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionIsActive = sessionManager.isConnected
        self.mediaPlayer = MediaPlayer(queue: sessionManager._queue)
    }
    
    /**
     Handles the button press for the search button.
     */
    func handleSearchButtonPressed() {
        self.isSearching = true
    }
    
    /**
     Loads songs asynchronously.
     */
    private func loadSongs() async throws {
        // Code to load songs
    }
}
