//
//  SongSearchView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import SwiftUI
import Combine

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
            self.sessionManager.searchSongs(query: query) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let songs):
                        self?.songs = songs
                    case .failure(let error):
                        print("Error searching songs \(error)")
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
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        // Observe changes in session manager queue
        sessionManager.$songAdded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.songAdded = true
            }
            .store(in: &cancellables)
    }
    
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
