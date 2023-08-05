//
//  QueueView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

struct QueueView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var musicService: AnyMusicService
    
    @State private var isShowingSearchView: Bool = false
    
    init(sessionManager: SessionManager, musicService: AnyMusicService) {
        self.sessionManager = sessionManager
        self.musicService = musicService
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: handleAddSongButtonTapped) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                }
                .padding([.top])
                .sheet(isPresented: $isShowingSearchView) {
                    SongSearchView(musicService: musicService) { selectedSong in
                        if let session = sessionManager.activeSession {
                            sessionManager.addSongToQueue(sessionId: session.id, song: selectedSong)
                        }
                        
                        isShowingSearchView = false
                    }
                }
            }
            List(((sessionManager.activeSession?.queue.isEmpty)! ? [] : sessionManager.activeSession?.queue)!) { song in
                MusicItemCell(artworkURL: song.artworkURL, title: song.title, artist: song.artist)
                HStack {
                    Button(action: {
                        sessionManager.voteSong(sessionId: "", songID: song.id.rawValue, vote: 1)
                    }) {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.blue)
                    }

                    Button(action: {
                        sessionManager.voteSong(sessionId: "", songID: song.id.rawValue, vote: -1)
                    }) {
                        Image(systemName: "hand.thumbsdown")
                            .foregroundColor(.red)
                    }
                    Text("Votes: \(song.votes)")
                }
            }
        }
    }
    
    /// Handle add song button tapped
    private func handleAddSongButtonTapped() {
        self.isShowingSearchView = true
    }
    private func test() async {
        Task {
            try await self.musicService.fetchUser()
        }
    }
}
