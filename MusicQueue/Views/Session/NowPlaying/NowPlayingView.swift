// MARK: - CodeAI Output
/**
 This code represents the view for a session in an app. It displays various components such as a title, now playing information, audio controls, and a menu bar. It also includes functionality for handling button presses and managing the session.
 */

import SwiftUI
import Combine

struct NowPlayingView: View {
    @ObservedObject private var viewModel = NowPlayingViewModel()
    
    @State private var showingQueue: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    
                } else {
                    AlbumArtView(currentArtwork: viewModel.artworkImage)
                }
                
                AudioControlView(isHost: false)
            }
            .blur(radius: showingQueue ? 3 : 0)
            .disabled(showingQueue)
            .padding()
        
            if showingQueue {
                SessionQueueView()
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

class NowPlayingViewModel: ObservableObject {
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    @State var isLoading = false
    @Published var artworkImage: UIImage
    
    private let defaultArtwork = UIImage(named: "defaultArtwork")!
    private var songResolver = SongResolver()
    
    init() {
        self.artworkImage = defaultArtwork
        setupCurrentSongChangeSubscriber()
    }
    
    
    private func setupCurrentSongChangeSubscriber() {
        notificationCenter.addObserver(self, selector: #selector(currentSongChangedHandler(_:)), name: .currentSongChangedNotification, object: nil)
    }
    
    @objc private func currentSongChangedHandler(_ notification: Notification) async {
        guard let song = notification.object as? (SongProtocol) else {
            return
        }
        resolveArtwork(for: song.artworkImageURL(size: CGSize(width: 300, height: 300)))
    }
    
    func resolveArtwork(for url: URL?) {
        isLoading = true
        Task {
            let resolvedImage = await songResolver.resolveArtwork(for: url)
            DispatchQueue.main.async { [weak self] in
                self?.artworkImage = resolvedImage
                self?.isLoading = false
            }
        }
    }
}

// MARK: - NowPlayingView Preview

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
            .environmentObject(SessionManager()) // If you use environment objects
    }
}
