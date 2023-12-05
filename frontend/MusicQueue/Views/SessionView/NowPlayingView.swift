//
//  NowPlayingView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import SwiftUI
import MusicKit
import Combine

struct NowPlayingView: View {
    
    
    @ObservedObject var viewModel: NowPlayingViewModel
    @ObservedObject var mediaPlayer: MediaPlayer
    
    
    init(mediaPlayer: MediaPlayer) {
        viewModel = NowPlayingViewModel(mediaPlayer: mediaPlayer)
        self.mediaPlayer = mediaPlayer
    }

    var body: some View {
        VStack {
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
        .animation(.default, value: viewModel.loadedImage)
        .frame(width: viewModel.screenWidth * 0.85, height: viewModel.screenHeight * 0.3)
        .clipped()
        .transition(.opacity)
    }
}

class NowPlayingViewModel: ObservableObject {
    
    // Get screen dimenesions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @ObservedObject var mediaPlayer: MediaPlayer
    @Published var loadedImage: UIImage?
    @Published var artwork: MusicKit.Artwork?
    
    let albumArtPlaceholder = Image(systemName: "photo")
    private var cancellables = Set<AnyCancellable>()
    
    init(mediaPlayer: MediaPlayer) {
        self.mediaPlayer = mediaPlayer
        
        // Listen for changes to the current song.
        mediaPlayer.$currentEntry
            .sink { [weak self] entry in
                if let _entry = entry {
                    self?.resolveArtwork(currentEntry: _entry)
                }
            }
            .store(in: &cancellables)
    }
    
    func resolveArtwork(currentEntry: AnyMusicItem) {
        Task {
            if let artwork = currentEntry.artwork {
                self.artwork = artwork
                self.loadedImage = nil
                print("load from artwork")
            }
            if let artworkUrl = try await mediaPlayer.currentSongArtworkUrl(width: Int(screenWidth * 0.85), height: Int(screenHeight * 0.3)) {
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
