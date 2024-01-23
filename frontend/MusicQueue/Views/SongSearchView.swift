//
//  SongSearchView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import SwiftUI
import Combine
import os

struct SongSearchView: View {
    
    @ObservedObject var songSearchViewModel: SongSearchViewModel
    
    init(sessionManager: SessionManager) {
        let viewModel = SongSearchViewModel(sessionManager: sessionManager)
        self.songSearchViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search songs", text: $songSearchViewModel.query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                List(songSearchViewModel.songs) { song in
                    SearchMusicItemCell(
                        song: song,
                        songInQueue: Binding<Bool>(
                            get: { songSearchViewModel.songInQueue(song) },
                            set: { _ in }
                        ),
                        onAddToQueue: {
                            songSearchViewModel.addSongToQueue(song)
                        }
                    )
                }
            }
            .navigationTitle("Song Search")
        }
        Spacer()
    }
}

// MARK: - View Model

class SongSearchViewModel: ObservableObject {
    let logger = Logger()
    
    let searchManager: SearchManager
    
    @Published var songs: [AnyMusicItem] = []
    @Published var songAdded: Bool = false
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.searchManager = (UserPreferences.getUserMusicService() == .apple) ? SearchManager(AppleMusicSearchManager()): SearchManager(SpotifySearchManager())
        
        sessionManager.$songAdded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.songAdded = true
            }
            .store(in: &cancellables)
    }
    
    
    @Published var query: String = "" {
        didSet {
            self.searchManager.searchSongs(query: query, limit: 20) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let songs):
                        self?.songs = songs
                    case .failure(let error):
                        self?.logger.log(level: .error, "\(error.localizedDescription)")
                        self?.songs = []
                    }
                }
            }
        }
    }
    
    let musicServiceType: String = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
    let sessionManager: SessionManager
    
    private var cancellables = Set<AnyCancellable>()
    
    func songInQueue(_ song: AnyMusicItem) -> Bool {
        sessionManager.getQueuedSongs().contains(where: { $0.id == song.id })
    }
    
    func addSongToQueue(_ song: AnyMusicItem) {
        do {
            if !songInQueue(song) {
                try sessionManager.addSong(song: song)
            }
        } catch {
            print("Error adding song")
        }
    }
}

struct SongSearchView_Preview: PreviewProvider {
    
    static var previews: some View {
        let sessionManager = SessionManager()
        SongSearchView(sessionManager: sessionManager)
    }
}
