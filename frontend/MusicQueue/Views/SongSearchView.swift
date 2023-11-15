//
//  SongSearchView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import SwiftUI
import MusicKit
import MusicKit

struct SongSearchView: View {
    
    @ObservedObject var songSearchViewModel: SongSearchViewModel
    init(sessionManager: SessionManager) {
        self.songSearchViewModel = SongSearchViewModel(sessionManager: sessionManager)
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
    @Published var query: String = "" {
        didSet {
            self.searchManager.searchSongs(query: query) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let songs):
                        self?.songs = songs
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.songs = []
                    }
                }
            }
        }
    }
    
    @Published var songs: [AnyMusicItem] = []
    @Published var songAdded: Bool = false
    
    let musicServiceType: String = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
    let sessionManager: SessionManager
    let searchManager: SearchManager
    
    init(sessionManager: SessionManager) {
//        searchManager = ((musicServiceType == "apple") ? SearchManager(AppleMusicSearchManager()) : SearchManager(SpotifySearchManager()))
        searchManager = SearchManager(AppleMusicSearchManager())
        self.sessionManager = sessionManager
    }
    
    func songInQueue(_ song: AnyMusicItem) -> Bool {
        sessionManager.getQueueItems().contains(where: { $0.id == song.id })
    }
    
    func addSongToQueue(_ song: AnyMusicItem) {
        if !songInQueue(song) {
            sessionManager.enqueue(song: song)
            songAdded = true
        }
    }
}

struct SongSearchView_Preview: PreviewProvider {
    
    static var previews: some View {
        let sessionManager = SessionManager()
        SongSearchView(sessionManager: sessionManager)
    }
}
