// MARK: - CodeAI Output
/**
 This class represents a generic song queue.
 
 The `SongQueue` class is a generic class that can hold elements of any type that conforms to the `Identifiable` protocol. It provides methods for managing and manipulating the queue.
 */
import SwiftUI
import os

class SongQueue: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    
    @Published private var array: [SongProtocol] = []
    @Published private(set) var currentSong: (SongProtocol)?
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    func getQueueItems() -> [SongProtocol] {
        return array
    }
    
    func find(id: String) -> (SongProtocol)? {
        return array.first(where: { $0.id == id })
    }
    
    func contains(songId: String) -> Bool {
        return find(id: songId) != nil
    }
    
    func next() -> (SongProtocol)? {
        guard let currentIndex = array.firstIndex(where: { $0.id == currentSong?.id }),
              currentIndex < array.index(before: array.endIndex) else {
            logger.debug("No next element in queue.")
            return nil
        }
        let nextIndex = array.index(after: currentIndex)
        currentSong = array[nextIndex]
        return currentSong
    }
    
    func previous() -> (SongProtocol)? {
        guard let currentIndex = array.firstIndex(where: { $0.id == currentSong?.id }),
              currentIndex > array.startIndex else {
            logger.debug("No previous element in queue.")
            return nil
        }
        let previousIndex = array.index(before: currentIndex)
        currentSong = array[previousIndex]
        return currentSong
    }
    
    func removeItem(id: String) {
        guard let index = array.firstIndex(where: { $0.id == id }) else {
            return
        }
        array.remove(at: index)
        if array.isEmpty {
            currentSong = nil
        } else if index == 0 {
            currentSong = array.first
        }
    }
    
    func reset() {
        currentSong = array.first
    }
    
    func enqueue(newElement: SongProtocol) {
        array.append(newElement)
        if array.count == 1 {
            currentSong = newElement
        }
    }
}
