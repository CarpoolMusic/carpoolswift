//
//  QueueView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import Combine
import os

struct MusicCellView: View {
    var song: AnyMusicItem
    var queueViewModel: QueueViewModel
    
    var body: some View {
        HStack {
            // Assuming `song` has properties like `title` and `artist`
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            // Additional controls or information can go here, if any.
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        // Additional visual styling
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct SessionQueueView: View {
    private let queueViewModel = QueueViewModel()
    
    var body: some View {
        VStack {
            if queueViewModel.getSongs().isEmpty {
                EmptyQueueView()
            } else {
                SongQueueList(queueViewModel: queueViewModel)
            }
        }
    }
}

struct EmptyQueueView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.secondary)
            Text("Your song queue is currently empty.\nSearch for songs to add to your queue.")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .padding()
    }
}

struct SongQueueList: View {
    @ObservedObject var queueViewModel: QueueViewModel
    
    var body: some View {
        List {
            ForEach(queueViewModel.getSongs(), id: \.id) { song in
                MusicCellView(song: song, queueViewModel: queueViewModel)
                    .swipeActions {
                        Button(role: .destructive) {
                            queueViewModel.removeSong(songId: song.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
}

class QueueViewModel: ObservableObject {
    @Injected private var notificationCenter: NotificationCenterProtocol
    @Injected private var logger: CustomLogger
    @Injected private var sessionManager: SessionManager
    
    private var cancellables = Set<AnyCancellable>()
    
    func removeSong(songId: String) {
        guard let activeSession = sessionManager.getActiveSession() else {
            logger.error("Trying to delete song from queue with no active session.")
            return
        }
        
        activeSession.removeSong(songId: songId) { result in
            switch result {
            case .failure(let error):
                self.logger.error(error.localizedDescription)
            case .success():
                self.logger.debug("Removed song \(songId)")
            }
        }
    }
    
    func getSongs() -> [AnyMusicItem] {
        guard let activeSession = sessionManager.getActiveSession() else {
            logger.error("Trying to get songs in queue with no active session.")
            return []
        }
        return activeSession.getQueuedSongs()
    }
}

//struct QueueViewModel_Previews: PreviewProvider {
//    static var previews: some View {
//        let sessionManager = SessionManager()
//        SessionQueueView(sessionManager: sessionManager)
//    }
//}
