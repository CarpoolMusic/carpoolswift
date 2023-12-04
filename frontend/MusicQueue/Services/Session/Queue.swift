//
//  Queue.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-16.
//

import Foundation

class Queue: ObservableObject {
    
    @Published var updated: Bool = false
    
    private var _queue: Array<AnyMusicItem> = []
    
    func enqueue(song: AnyMusicItem) {
        self._queue.append(song)
        updated.toggle()
    }
    
    func dequeue() -> AnyMusicItem? {
        if self._queue.isEmpty {
            return nil
        } else {
            updated.toggle()
            return _queue.removeFirst()
        }
    }
    
    var isEmpty: Bool {
        return _queue.isEmpty
    }
    
    var front: AnyMusicItem? {
        return _queue.first
    }
    
    func getQueueItems() -> Array<AnyMusicItem> {
        return self._queue
    }
    
    func upvote(songId: String) {
        if let index = _queue.firstIndex(where: { $0.id.rawValue == songId }) {
            _queue[index].votes += 1
            // Check if a resort is required
            if index > 0 && _queue[index].votes > _queue[index - 1].votes {
                self.sortQueue()
            }
        }
    }
    
    func donwvote(songId: String) {
        if let index = _queue.firstIndex(where: { $0.id.rawValue == songId }) {
            _queue[index].votes -= 1
            if index < _queue.count - 1 && _queue[index].votes < _queue[index + 1].votes {
                sortQueue()
            }
        }
    }
    
    
    private func sortQueue() {
        _queue.sort { (song1, song2) -> Bool in
            updated.toggle()
            return song1.votes > song2.votes
        }
    }
    
}
