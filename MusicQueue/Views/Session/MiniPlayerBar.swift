import SwiftUI

struct MiniPlayerBar: View {
    @Binding var showingNowPlaying: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "music.note")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .clipped()
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
                .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 2) {
                Text("Song Name").bold().font(.footnote)
                Text("Artist Name").font(.caption).foregroundColor(.secondary)
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
        MiniPlayerBar(showingNowPlaying: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

