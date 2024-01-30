//
//  SpotifyQueue.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-15.
//
import os

class SongQueue<T: Identifiable> : ObservableObject {
    let logger = Logger()
    
    private var array: [T]
    private var currentIndex: Int

    init() {
        self.array = []
        self.currentIndex = array.startIndex
    }

    var current: T? {
        if !array.indices.contains(currentIndex) {
            logger.log(level: .debug, "No current element in queue.")
            return nil
        }
        return array[currentIndex]
    }
    
    func getQueueItems() -> [T] {
        return self.array
    }
    
    func find(id: String) -> T? {
        if let index = array.firstIndex(where: { $0.id as! String == id }) {
            return array[index]
        }
        return nil
    }
    
    func next() -> T? {
        guard !array.isEmpty, currentIndex < array.index(before: array.endIndex) else {
            logger.log(level: .debug, "No next element in queue.")
            return nil
        }
        currentIndex = array.index(after: currentIndex)
        return array[currentIndex]
    }

    // If there is no previous entry then just return the current entry
    func previous() -> T? {
        guard !array.isEmpty, currentIndex > array.startIndex else {
            logger.log(level: .debug, "No next element in queue.")
            return nil
        }
        currentIndex = array.index(before: currentIndex)
        return array[currentIndex]
    }
    
    func removeItem(id: String) -> Void {
        if let index = array.firstIndex(where: { $0.id as! String == id }) {
            array.remove(at: index)
        }
    }

    func reset() {
        currentIndex = array.startIndex
    }
    
    func enqueue(newElement: T) {
        array.append(newElement)
    }
}
