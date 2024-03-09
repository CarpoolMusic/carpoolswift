// MARK: - CodeAI Output
/**
 This code represents the view for a session in an app. It displays various components such as a title, now playing information, audio controls, and a menu bar. It also includes functionality for handling button presses and managing the session.
 */

import SwiftUI
import Combine

struct NowPlayingView: View {
    
    @ObservedObject var sessionViewModel: NowPlayingViewModel
    @State private var showingQueue: Bool = false
    
    init(sessionManager: SessionManager) {
        self.sessionViewModel = NowPlayingViewModel(sessionManager: sessionManager)
    }
    
    var body: some View {
        ZStack {
            VStack {
                AlbumArtView(mediaPlayer: sessionViewModel.mediaPlayer)
                
                Spacer()
                
                AudioControlView(mediaPlayer: sessionViewModel.mediaPlayer, isHost: sessionViewModel.sessionManager.isHost())
                
                Spacer()
            }
            .blur(radius: showingQueue ? 3 : 0)
            .disabled(showingQueue)
            .padding()
        
            if showingQueue {
                QueueView(sessionManager: sessionViewModel.sessionManager)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
            
            VStack {
                Spacer()
                
                PlayerControlView(showingQueue: $showingQueue)
                    .zIndex(2)
            }
        }
    }
}

/**
 This class represents the view model for a session. It manages the state and functionality of the view.
 */

class NowPlayingViewModel: ObservableObject {
    
    @Published private var isPlaying = false
    @Published var sessionManager: SessionManager
    @Published var mediaPlayer: MediaPlayer
    @Published var sessionIsActive = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionIsActive = sessionManager.isConnected
        self.mediaPlayer = MediaPlayer(queue: sessionManager._queue)
    }
    
    /**
     Loads songs asynchronously.
     */
    private func loadSongs() async throws {
        // Code to load songs
    }
}


// MARK: - NowPlayingView Preview

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock instances of your dependencies
        let mockSessionManager = MockSessionManager()
        let mockMediaPlayer = MockMediaPlayer(queue: mockSessionManager._queue)

        // Return the SessionView for preview
        NowPlayingView(sessionManager: mockSessionManager)
            .environmentObject(mockSessionManager) // If you use environment objects
    }
}
