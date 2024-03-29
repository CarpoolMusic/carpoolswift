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
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search songs", text: $songSearchViewModel.query)
                }
                .padding(.all, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
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
                    .listRowBackground(songSearchViewModel.songInQueue(song) ? Color.green.opacity(0.1) : Color.clear)
                }
            }
            .navigationTitle("Song Search")
        }
        .accentColor(.primary)
    }
}

// MARK: - View Model

class SongSearchViewModel: ObservableObject {
    let logger = Logger()
    
    let searchManager: SearchManager
    
    @Published var songs: [AnyMusicItem] = []
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.searchManager = (UserPreferences.getUserMusicService() == .apple) ? SearchManager(AppleMusicSearchManager()): SearchManager(SpotifySearchManager())
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
            logger.error("Error adding song")
        }
    }
}

struct SongSearchView_Preview: PreviewProvider {
    
    static var previews: some View {
        let sessionManager = SessionManager(sessionId: "", sessionName: "", hostName: "")
        SongSearchView(sessionManager: sessionManager)
    }
}
