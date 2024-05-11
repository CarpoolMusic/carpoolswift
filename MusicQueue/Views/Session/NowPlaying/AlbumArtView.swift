import SwiftUI
import MusicKit
import Combine

struct AlbumArtView: View {
    @ObservedObject var viewModel = AlbumArtViewModel()
    
    @EnvironmentObject private var session: Session
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var currentSong: (SongProtocol)?

    var body: some View {
        VStack {
            ZStack {
                // Gradient background (optional dynamic adaptation)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight * 0.4)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                ArtworkImageView(artworkURL: currentSong?.artworkImageURL(size: CGSize(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight *  0.4)))
                    .frame(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight * 0.4)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 10)
                    .animation(.easeInOut, value: viewModel.artworkImage)
                    .transition(.opacity)
            }
        }
        .onAppear {
            setupSubscriptions()
        }
        .edgesIgnoringSafeArea(.all)
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

class AlbumArtViewModel: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    @Published var currentArtworkURL: URL?
    
    // Get screen dimenesions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @Published var isLoading: Bool = false
    @Published var artworkImage: UIImage?
    
    var songResolver = SongResolver()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupCurrentSongChangeSubscriber()
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
    
    private func setupCurrentSongChangeSubscriber() {
        notificationCenter.addObserver(self, selector: #selector(currentSongChangedHandler(_:)), name: .currentSongChangedNotification, object: nil)
    }
    
    @objc private func currentSongChangedHandler(_ notification: Notification) async {
        guard let song = notification.object as? (SongProtocol) else {
            return
        }
        resolveArtwork(for: song.artworkImageURL(size: CGSize(width: 300, height: 300)))
    }
}

//struct NowPlayingView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumArtView(currentSong: song)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
