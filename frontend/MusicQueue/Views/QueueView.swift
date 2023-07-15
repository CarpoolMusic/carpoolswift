//
//  QueueView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

struct QueueView: View {
    @Environment(\.dismiss) var dismiss
    var session: SessionManager
    var queue: [Song]

    var body: some View {
        VStack {
            List(queue, id: \.id) { song in
                VStack(alignment: .leading) {
                    Text(song.title)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Button(action: {
                        session.voteSong(sessionId: "\(session.sessionID)", songID: song.id, vote: 1)
                    }) {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.blue)
                    }

                    Button(action: {
                        session.voteSong(sessionId: "\(session.sessionID)", songID: song.id, vote: -1)
                    }) {
                        Image(systemName: "hand.thumbsdown")
                            .foregroundColor(.red)
                    }
                    Text("Votes: \(song.votes)")
                }
            }
            .padding([.top, .bottom])
        }
    }
}