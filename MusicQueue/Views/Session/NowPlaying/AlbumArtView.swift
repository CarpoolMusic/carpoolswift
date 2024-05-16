import SwiftUI
import MusicKit
import Combine
import SDWebImageSwiftUI

// Global constants
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let ALBUM_ART_CG_SIZE = CGSize(width: screenWidth * 0.85, height: screenHeight *  0.4)


struct AlbumArtView: View {
    @EnvironmentObject private var session: Session
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var currentSong: (SongProtocol)?

    var body: some View {
        VStack {
            ZStack {
                // Gradient background (optional dynamic adaptation)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: ALBUM_ART_CG_SIZE.width, height: ALBUM_ART_CG_SIZE.height)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                WebImage(url: currentSong?.artworkImageURL(size: ALBUM_ART_CG_SIZE))
                    .resizable()
                    .scaledToFill()
                    .frame(width: ALBUM_ART_CG_SIZE.width, height: ALBUM_ART_CG_SIZE.height)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 10)
//                    .animation(.easeInOut, value: viewModel.artworkImage)
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
//struct NowPlayingView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumArtView(currentSong: song)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
