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
    
    func find(id: String) -> AnyMusicItem? {
        if let index = _queue.firstIndex(where: { $0.id == id }) {
            return _queue[index]
        }
        return nil
    }
    
    private func sortQueue() {
        _queue.sort { (song1, song2) -> Bool in
            updated.toggle()
            return song1.votes > song2.votes
        }
    }
    
}
