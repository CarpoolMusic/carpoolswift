import SwiftUI
import MusicKit

struct BaseMusicItemCell: View {
    private let artworkURL: URL?
    private let title: String
    private let artist: String
    
    init(song: SongProtocol) {
        self.title = song.songTitle
        self.artist = song.artist
        self.artworkURL = song.artworkImageURL(size: CGSize(width: 300, height: 300))
    }
    
    var body: some View {
        HStack {
            ArtworkImageView(artworkURL: artworkURL)
                .frame(width: 50, height: 50)
                .cornerRadius(8)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                Text(artist)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ArtworkImageView: View {
    let artworkURL: URL?
    
    var body: some View {
        AsyncImage(url: artworkURL) { image in
            image
                .resizable() // This allows the image to be resized
                .aspectRatio(contentMode: .fit) // This makes sure the image fits within the view bounds
        } placeholder: {
            ProgressView() // This will display a progress indicator while the image is loading
        }
        .frame(width: 50, height: 50) // Set the frame of the image
        .clipped() // This will clip off any parts of the image that do not fit in the frame
    }
}
