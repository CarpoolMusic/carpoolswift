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
    @Injected private var logger: CustomLogger
    
    @Published var songs: [AnyMusicItem] = []
    
    private let searchManager: SearchManager
    
    
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
                        self?.logger.error("\(error.localizedDescription)")
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
        guard let session = sessionManager.getActiveSession() else {
            logger.error("Checkf for song but no active queue")
            return false
        }
        return session.contains(songId: song.id)
    }
    
    func addSongToQueue(_ song: AnyMusicItem) {
        guard let session = sessionManager.getActiveSession() else {
            logger.error("Check for song but no active queue")
            return
        }
        
        if session.contains(songId: song.id) {
            logger.debug("Song \(song.id) already in queue.")
            return
        }
    }
}

struct SongSearchView_Preview: PreviewProvider {
    
    static var previews: some View {
        let sessionManager = SessionManager()
        SongSearchView(sessionManager: sessionManager)
    }
}
