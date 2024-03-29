import SwiftUI

struct MiniPlayerBar: View {
    @Binding var showingNowPlaying: Bool

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "music.note")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 2))
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 4) {
                Text("Song Name").bold()
                Text("Artist Name").font(.subheadline).foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                // Placeholder for play/pause action
            }) {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
        }
        .padding([.leading, .trailing, .top, .bottom], 10)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding([.leading, .trailing], 10)
        .onTapGesture {
            showingNowPlaying.toggle()
        }
    }
}

// Preview
struct MiniPlayerBar_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayerBar(showingNowPlaying: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

