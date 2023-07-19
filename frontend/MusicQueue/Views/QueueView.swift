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
                        sessionManager.addSongToQueue(sessionId: sessionManager.activeSession!.id, songData: [:])
                        
                        isShowingSearchView = false
                    }
                }
            }
            List(sessionManager.activeSession?.queue ?? []) { song in
                MusicItemCell(artwork: song.song.artwork, title: song.song.title)
                //                VStack(alignment: .leading) {
                //                    Text(song.title)
                //                    Text(song.artist)
                //                        .font(.subheadline)
                //                        .foregroundColor(.secondary)
                //                }
                //                HStack {
                //                    Button(action: {
                //                        sessionManager.voteSong(sessionId: "", songID: song.id, vote: 1)
                //                    }) {
                //                        Image(systemName: "hand.thumbsup")
                //                            .foregroundColor(.blue)
                //                    }
                //
                //                    Button(action: {
                //                        sessionManager.voteSong(sessionId: "", songID: song.id, vote: -1)
                //                    }) {
                //                        Image(systemName: "hand.thumbsdown")
                //                            .foregroundColor(.red)
                //                    }
                //                    Text("Votes: \(song.votes)")
                //                }
                //            }
                //            .padding([.top, .bottom])
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
