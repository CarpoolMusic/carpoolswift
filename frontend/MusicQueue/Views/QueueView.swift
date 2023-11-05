//
//  QueueView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

struct QueueView: View {
    
    @ObservedObject var queueViewModel: QueueViewModel
    
    init(sessionManager: SessionManager) {
        self.queueViewModel = QueueViewModel(sessionManager: sessionManager)
    }
    
    var body: some View {
        VStack {
            if (queueViewModel.sessionManager.getQueueItems().isEmpty) {
                Image(systemName: "magnifyingglass")
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                Text("Your song queue is currently empty. Click the ") + Text(Image(systemName: "magnifyingglass")) + Text(" to search for songs")
            }
            List {
                ForEach(queueViewModel.sessionManager.getQueueItems(), id: \.id) { song in
                    MusicItemCell(artworkURL: song.artworkURL, title: song.title, artist: song.artist)
                    HStack {
                        Button(action: {
                            queueViewModel.sessionManager.voteSong(songId: song.id, vote: 1)
                        }) {
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            queueViewModel.sessionManager.voteSong(songId: song.id, vote: -1)
                        }) {
                            Image(systemName: "hand.thumbsdown")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}

class QueueViewModel: ObservableObject {
    
    var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
}
