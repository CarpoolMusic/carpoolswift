import SwiftUI
import MusicKit
import Combine

struct AlbumArtView: View {
    @ObservedObject var viewModel: AlbumArtViewModel
    @ObservedObject var mediaPlayer: MediaPlayer
    
    init(mediaPlayer: MediaPlayer) {
        viewModel = AlbumArtViewModel(mediaPlayer: mediaPlayer)
        self.mediaPlayer = mediaPlayer
    }

    var body: some View {
        VStack {
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
                }
            }
//            .aspectRatio(contentMode: .fill)
            .frame(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight * 0.4)
            .cornerRadius(20) // This rounds the corners of the image
            .overlay(
                RoundedRectangle(cornerRadius: 20) // This adds a border around the image
                    .stroke(Color.white, lineWidth: 4)
            )
            .shadow(radius: 10)
            .padding(.top, 50)
            .animation(.default, value: viewModel.loadedImage)
            .transition(.opacity)
        }
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

class AlbumArtViewModel: ObservableObject {
    
    // Get screen dimenesions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @ObservedObject var mediaPlayer: MediaPlayer
    @Published var loadedImage: UIImage?
    @Published var artwork: MusicKit.Artwork?
    
    let albumArtPlaceholder = Image(systemName: "music.note")
    private var cancellables = Set<AnyCancellable>()
    
    init(mediaPlayer: MediaPlayer) {
        self.mediaPlayer = mediaPlayer
        
        // Listen for changes to the current song.
        mediaPlayer.$currentEntry
            .sink { [weak self] entry in
                if let _entry = entry {
                    self?._resolveArtwork(currentEntry: _entry)
                }
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
        // Mock data for preview
        let mockMediaPlayer = MediaPlayer(queue: MockSongQueue())
        AlbumArtView(mediaPlayer: mockMediaPlayer)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
