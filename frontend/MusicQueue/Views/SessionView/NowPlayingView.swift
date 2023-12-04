//
//  NowPlayingView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import SwiftUI
import Combine

struct NowPlayingView: View {
    
    let viewModel: NowPlayingViewModel
    init(mediaPlayer: MediaPlayer) {
        viewModel = NowPlayingViewModel(mediaPlayer: mediaPlayer)
    }
    
    // Get screen dimenesions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    
    var body: some View {
        VStack {
            Group {
                if let artworkImage = viewModel.loadedImage {
                    Image(uiImage: artworkImage)
                        .resizable()
                } else {
                    viewModel.albumArtPlaceholder
                        .resizable()
                }
            }
            .frame(width: screenWidth * 0.85, height: screenHeight * 0.3)
            .clipped()
            .transition(.opacity)
        }
        .onChange(of: viewModel.mediaPlayer.newCurrentSong) { _ in
            print("ON CHANGE POF")
            viewModel.resolveArtwork()
        }
    }
}

class NowPlayingViewModel {
    
    
    @ObservedObject var mediaPlayer: MediaPlayer
    
    let albumArtPlaceholder = Image(systemName: "photo")
    var loadedImage: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    init(mediaPlayer: MediaPlayer) {
        self.mediaPlayer = mediaPlayer
    }
    
    func resolveArtwork() {
        print("RESOLVING ARTWORK")
        Task {
            if let artworkUrl = try await mediaPlayer.currentSongArtworkUrl() {
                loadImage(from: artworkUrl)
                print("Resolved artwork done", artworkUrl)
            } else {
                print("Error resolving artwork from URL")
            }
        }
    }
    
    func loadImage(from url: URL) {
        print("Trying to load image")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {                
                    print("LOADED THE IMAGE")
                    self.loadedImage = image
                }
            } else {
                print("Error loading the image from URL")
            }
        }.resume()
    }
    
}
