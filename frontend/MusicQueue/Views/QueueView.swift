//
//  QueueView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import Combine

struct MusicCellView: View {
    var song: AnyMusicItem
    var queueViewModel: QueueViewModel
    
    var body: some View {
        QueueMusicItemCell(song: song, sessionManager: queueViewModel.sessionManager)
    }
}

struct QueueView: View {
    
    
    @ObservedObject var queueViewModel: QueueViewModel
    
    init(sessionManager: SessionManager) {
        self.queueViewModel = QueueViewModel(sessionManager: sessionManager)
    }
    
    var body: some View {
        if (queueViewModel.sessionManager.getQueuedSongs().isEmpty) {
            Image(systemName: "magnifyingglass")
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
            Text("Your song queue is currently empty. Click the ") + Text(Image(systemName: "magnifyingglass")) + Text(" to search for songs")
        } else {
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
            .animation(.default, value: queueViewModel.sessionManager.queueUpdated)
            .searchable(text: $queueViewModel.searchTerm, prompt: "Songs")
            
        }
    }
}

class QueueViewModel: ObservableObject {
    
    @Published var sessionManager: SessionManager
    var searchTerm = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func removeSong(songId: String) {
        do {
            try self.sessionManager.socketEventSender.removeSong(sessionId: self.sessionManager._session.sessionId, songID: songId)
        } catch {
            print("Error deleting song from queue")
        }
    }
    
}

struct QueueViewModel_Previews: PreviewProvider {
    static var previews: some View {
        let sessionManager = SessionManager()
        QueueView(sessionManager: sessionManager)
    }
}
