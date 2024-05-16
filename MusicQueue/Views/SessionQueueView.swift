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
    var song: SongProtocol
    var queueViewModel: QueueViewModel
    
    var body: some View {
        HStack {
            BaseMusicItemCell(song: song)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
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
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var sessionManager: any SessionManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func removeSong(songId: String) {
        guard let activeSession = sessionManager.activeSession else {
            logger.error("Trying to delete song from queue with no active session.")
            return
        }
        
        activeSession.removeSong(songId: songId) { result in
            switch result {
            case .failure(let error):
                self.logger.error(error.localizedDescription)
            case .success():
                self.sessionManager.activeSession?.queue.removeItem(id: songId)
                self.logger.debug("Removed song \(songId)")
            }
        }
    }
    
    func getSongs() -> [SongProtocol] {
        guard let activeSession = sessionManager.activeSession else {
            logger.error("Trying to get songs in queue with no active session.")
            return []
        }
        return activeSession.queue.getQueueItems()
    }
}

struct QueueViewModel_Previews: PreviewProvider {
    static var previews: some View {
        SessionQueueView()
    }
}
