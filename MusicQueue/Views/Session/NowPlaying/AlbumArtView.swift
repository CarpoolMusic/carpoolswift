import SwiftUI
import MusicKit
import Combine

struct AlbumArtView: View {
    @ObservedObject var viewModel: AlbumArtViewModel

    init() {
        viewModel = AlbumArtViewModel()
    }

    var body: some View {
        VStack {
            ZStack {
                // Gradient background (optional dynamic adaptation)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight * 0.4)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                // Album artwork or placeholder
                Group {
                    if let artwork = viewModel.artwork {
                        ArtworkImage(artwork, width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight)
                    }
                    else if let artworkImage = viewModel.loadedImage {
                        Image(uiImage: artworkImage)
                            .resizable()
                    } else {
                        viewModel.albumArtPlaceholder
                            .resizable()
                            .foregroundColor(.gray)
                            .opacity(0.3) // Makes the placeholder less prominent
                    }
                }
                .frame(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight * 0.4)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(radius: 10)
                .animation(.easeInOut, value: viewModel.loadedImage)
                .transition(.opacity)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

class AlbumArtViewModel: ObservableObject {
    
    // Get screen dimenesions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @Published var loadedImage: UIImage?
    @Published var artwork: MusicKit.Artwork?
    
    let albumArtPlaceholder = Image("AlbumArtPlaceholder")
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupCurrentSongChangeSubscriber()
    }
    
    private func setupCurrentSongChangeSubscriber() {
        NotificationCenter.default.publisher(for: .currentSongChangedNotification)
            .compactMap { $0.object as? AnyMusicItem }
            .sink { [weak self] currentSong in
                self?._resolveArtwork(currentEntry: currentSong)
            }
            .store(in: &cancellables)
    }
    
    private func _resolveArtwork(currentEntry: AnyMusicItem) {
        if let artwork = currentEntry.artwork {
            self.artwork = artwork
            self.loadedImage = nil
            print("load from artwork")
        }
        else if let artworkImage = currentEntry.artworkImage {
            self.artwork = nil
            self.loadedImage = artworkImage
            print("Resolved artwork done")
        } else {
            print("Error resolving artwork from URL")
        }
    }
    
    private func _loadImage(from url: URL) {
        print("Trying to load image")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                    self.artwork = nil
                    print("load from image")
                    
                }
            } else {
                print("Error loading the image from URL")
            }
        }.resume()
    }
    
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumArtView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
