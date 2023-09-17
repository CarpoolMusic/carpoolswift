//
//  QueueView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

struct QueueView: View {
    
    private var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    var body: some View {
        VStack {
            HStack {
            }
            List(sessionManager.getQueueItems(), id: \.uri) { song in
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
            .onReceive(sessionManager.$queueUpdated) { _ in
                self.updateQueue.toggle()
            }
        }
    }
}

class QueueViewModel {
    
    @State private var isShowingSearchView: Bool = false
    @State private var updateQueue = false
    
    /// Handle add song button tapped
    private func handleAddSongButtonTapped() {
    }
}
