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
        VStack{}
//        VStack {
//            List(sessionManager.getQueueItems(), id: \.uri) { song in
//                MusicItemCell(artworkURL: song.artworkURL, title: song.title, artist: song.artist)
//                HStack {
//                    Button(action: {
//                        sessionManager.voteSong(songId: song.id, vote: 1)
//                    }) {
//                        Image(systemName: "hand.thumbsup")
//                            .foregroundColor(.blue)
//                    }
//                    Button(action: {
//                        sessionManager.voteSong(songId: song.id, vote: -1)
//                    }) {
//                        Image(systemName: "hand.thumbsdown")
//                            .foregroundColor(.red)
//                    }
//                }
//            }
//        }
    }
}

class QueueViewModel {
    
}
