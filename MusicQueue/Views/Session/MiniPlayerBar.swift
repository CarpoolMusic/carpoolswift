import SwiftUI

struct MiniPlayerBar: View {
    @Binding var showingNowPlaying: Bool
    
    @EnvironmentObject private var session: Session
    
    var body: some View {
        HStack(spacing: 12) {
            ArtworkImageView(artworkURL: session.queue.currentSong?.artworkImageURL(size: CGSize(width: 30, height: 30)))
            .frame(width: 30, height: 30)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
                .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.queue.currentSong?.songTitle ?? "").bold().font(.footnote)
                Text(session.queue.currentSong?.artist ?? "").font(.caption).foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
            }) {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(10)
        .shadow(radius: 3)
        .onTapGesture {
            showingNowPlaying.toggle()
        }
    }
}

// Preview
struct MiniPlayerBar_Previews: PreviewProvider {
    static var previews: some View {
        let session = Session(sessionId: "", sessionName: "", hostName: "")
        MiniPlayerBar(showingNowPlaying: .constant(false))
            .environmentObject(session)
            .previewLayout(.sizeThatFits)
    }
}

