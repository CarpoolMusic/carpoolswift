
import MusicKit
import SwiftUI

/// `MusicItemCell` is a view to use in a SwiftUI `List` to represent a `MusicItem`.
struct BaseMusicItemCell: View {
    
    // MARK: - Properties
    
    private let artwork: Artwork?
    private let artworkURL: URL?
    private let title: String
    private let artist: String
    
    init(song: AnyMusicItem, songInQueue: Binding<Bool> = .constant(false), onAddToQueue: @escaping () -> Void = {}, inSearch: Bool = false) {
        self.title = song.title
        self.artist = song.artist
        self.artwork = song.artwork
        self.artworkURL = song.artworkURL
    }
    
    // MARK: - View
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                if let artwork = self.artwork {
                    // Show apple music artwork
                    ArtworkImage(artwork, width: 50)
//                        .cornerRadius(6)
                } else if let artworkURL = self.artworkURL {
                    // Get Spotify artwork image from URL
                    AsyncImage(url: artworkURL)
//                        .cornerRadius(6)
                } else {
                    Image(systemName: "music.note.list")
                        .frame(width: 50, height: 50)
//                        .cornerRadius(6)
                }
                Spacer()
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

struct SearchMusicItemCell: View {
    let song: AnyMusicItem
    var songInQueue: Binding<Bool>
    var onAddToQueue: () -> Void
    
    var body: some View {
        HStack {
            BaseMusicItemCell(song: song)
            
            Spacer()
            
            if songInQueue.wrappedValue {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .transition(.scale)
            } else {
                Button(action: {
                    onAddToQueue()
                }) {
                    Image(systemName: "plus")
                }
                .transition(.scale)
            }
        }
    }
}

struct QueueMusicItemCell: View {
    let song: AnyMusicItem
    private var sessionManager: SessionManager
    @State private var thumbsUpPressed = false
    @State private var thumbsDownPressed = false
    
    init(song: AnyMusicItem, sessionManager: SessionManager) {
        self.song = song
        self.sessionManager = sessionManager
    }
    
    var body: some View {
        VStack {
            BaseMusicItemCell(song: song)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

            HStack {
                Button(action: {
                    do {
                        (thumbsUpPressed) ? try sessionManager.voteSong(songId: song.id.rawValue, vote: 1) : try sessionManager.voteSong(songId: song.id.rawValue, vote: -1)
                        thumbsUpPressed.toggle()
                        thumbsDownPressed = false
                    } catch {
                        print("Error downvoting on song")
                    }
                }) {
                    Image(systemName: thumbsUpPressed ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeInOut, value: thumbsUpPressed)
                
                Spacer()
                
                Button(action: {
                    do {
                        (thumbsDownPressed) ? try sessionManager.voteSong(songId: song.id.rawValue, vote: -1) : try sessionManager.voteSong(songId: song.id.rawValue, vote: 1)
                        thumbsDownPressed.toggle()
                        thumbsUpPressed = false
                    } catch {
                        print("Error upvoting song")
                    }
                }) {
                    Image(systemName: thumbsDownPressed ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeInOut, value: thumbsDownPressed)
            }
        }
    }
    
}

