
import MusicKit
import SwiftUI

/// `MusicItemCell` is a view to use in a SwiftUI `List` to represent a `MusicItem`.
struct MusicItemCell: View {
    
    // MARK: - Properties
    
    @State private var uiImage: UIImage? = nil
    let artworkURL: URL?
    let title: String
    let artist: String
    
    // MARK: - View
    
    var body: some View {
        HStack {
            Group {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipped()
                } else {
                    ProgressView() // or some placeholder content
                }
            }
            .task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: artworkURL!)
                    uiImage = UIImage(data: data)
                } catch {
                    // handle error
                    print("Failed to load image from \(String(describing: artworkURL)): \(error)")
                }
            }
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                Text(artist)
                    .lineLimit(1)
                    .foregroundColor(.primary)
            }
        }
    }
}

