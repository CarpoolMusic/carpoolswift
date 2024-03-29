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
    @ObservedObject var queueViewModel: QueueViewModel
    
    init(sessionManager: SessionManager) {
        self.queueViewModel = QueueViewModel(sessionManager: sessionManager)
    }
    
    var body: some View {
        VStack {
            if queueViewModel.sessionManager.getQueuedSongs().isEmpty {
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
            ForEach(queueViewModel.sessionManager.getQueuedSongs(), id: \.id) { song in
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
        .animation(.default, value: queueViewModel.queueUpdated)
        .searchable(text: $queueViewModel.searchTerm, prompt: "Search Songs")
    }
}

class QueueViewModel: ObservableObject {
    
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    @Published var sessionManager: SessionManager
    @Published var searchTerm = ""
    
    @Published var queueUpdated = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private var logger = Logger()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func removeSong(songId: String) {
        do {
            try self.sessionManager.removeSong(songId: songId)
        } catch {
            logger.error("Error deleting song from queue")
        }
    }
    
    private func subscribeToQueueNotifications() {
        notificationCenter.addObserver(self, selector: #selector(handleQueueUpdatedNotification(_:)), name: .queueUpdatedNotification, object: nil)
        
    }
    
    @objc private func handleQueueUpdatedNotification(_ notification: Notification) {
        self.queueUpdated = true
    }
    
}

struct QueueViewModel_Previews: PreviewProvider {
    static var previews: some View {
        let sessionManager = SessionManager()
        SessionQueueView(sessionManager: sessionManager)
    }
}
