import SwiftUI
import MusicKit

struct BaseMusicItemCell: View {
    private let artwork: Artwork?
    private let artworkURL: String?
    private let title: String
    private let artist: String
    
    init(song: AnyMusicItem) {
        self.title = song.title
        self.artist = song.artist
        self.artwork = song.artwork
        self.artworkURL = song.artworkURL
    }
    
    var body: some View {
        HStack {
            ArtworkImageView(artwork: artwork, artworkURL: artworkURL)
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
    let artwork: Artwork?
    let artworkURL: String?
    
    var body: some View {
        Group {
            if let artwork = artwork {
                // Assuming ArtworkImage is a provided view capable of displaying MusicKit.Artwork
                ArtworkImage(artwork, width: 50, height: 50)
            } else if let urlString = artworkURL, let url = URL(string: urlString) {
                // For loading and displaying an image from a URL
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .failure(_):
                        Image(systemName: "music.note")
                            .resizable()
                    default:
                        ProgressView()
                    }
                }
            } else {
                // Fallback placeholder image
                Image(systemName: "music.note")
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 50, height: 50)
        .clipped()
    }
}
