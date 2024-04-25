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
    @StateObject private var viewModel = SongSearchViewModel()
    
    @State private var searchQuery = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search songs", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: searchQuery) { newValue in
                            viewModel.searchManager.initiateSearch(query: newValue, limit: 10)
                        }
                }
                .padding(.all, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()

                List(viewModel.songs, id: \.id) { song in
                    SearchMusicItemCell(
                        song: song,
                        songInQueue: Binding<Bool>(
                            get: { viewModel.songInQueue(song) },
                            set: { _ in }
                        ),
                        onAddToQueue: {
                            viewModel.addSongToQueue(song)
                        }, cellTapped: false
                    )
                    .listRowBackground(viewModel.songInQueue(song) ? Color.green.opacity(0.1) : Color.clear)
                }
            }
        }
        .accentColor(.primary)
    }
}

// MARK: - View Model

class SongSearchViewModel: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var sessionManager: SessionManagerProtocol
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    var searchManager: SearchManager
    
    @Published var songs: [SongProtocol] = []
    
    
    let musicServiceType: String = UserDefaults.standard.string(forKey: "musicServiceType") ?? ""
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.searchManager = (UserPreferences.getUserMusicService() == .apple) ? SearchManager(AppleMusicSearchManager()): SearchManager(SpotifySearchManager())
        
        searchManager.$songs
            .receive(on: DispatchQueue.main)
            .assign(to: &$songs)
    }
    
    
    @Published var query: String = "" {
        didSet {
            searchManager.initiateSearch(query: query, limit: 20)
        }
    }
    
    func songInQueue(_ song: SongProtocol) -> Bool {
        guard let session = sessionManager.getActiveSession() else {
            logger.error("Check for song but no active queue")
            return false
        }
        return session.contains(songId: song.id)
    }
    
    func addSongToQueue(_ song: SongProtocol) {
        guard let session = sessionManager.getActiveSession() else {
            logger.error("Check for song but no active queue")
            return
        }
        
        if session.contains(songId: song.id) {
            logger.debug("Song \(song.id) already in queue.")
            return
        }
        
        Task {
            do {
                let status = try await session.addSong(song: song)
                if (status["status"] as? String == "success") {
                    print("POSTING SONG ADDED")
                    notificationCenter.post(name: .songAddedNotification, object: song)
                } else {
                    throw SongResolutionError(message: "Unable to add song to queue with error \(String(describing: status["message"]))")
                }
            } catch {
                logger.error("Unable to add song with error \(error)")
            }
        }
    }
}

struct SongSearchView_Preview: PreviewProvider {
    
    static var previews: some View {
        SongSearchView()
    }
}
