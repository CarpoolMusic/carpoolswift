//
//  Queue.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-11-16.
//

import Foundation

class Queue: ObservableObject {
    
    private var _queue: Array<AnyMusicItem> = []
    
    func enqueue(song: AnyMusicItem) {
        self._queue.append(song)
    }
    
    func dequeue() -> AnyMusicItem? {
        if self._queue.isEmpty {
            return nil
        } else {
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
        }
    }
    
    func donwvote(songId: String) {
        if let index = _queue.firstIndex(where: { $0.id.rawValue == songId }) {
            _queue[index].votes -= 1
        }
    }
    
    
}
