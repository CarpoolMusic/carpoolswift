// MARK: - CodeAI Output
/**
 This class represents a queue of music items.
 */
import Foundation

class Queue: ObservableObject {
    
    /**
     Indicates whether the queue has been updated.
     */
    @Published var updated: Bool = false
    
    /**
     The internal array that holds the music items in the queue.
     */
    private var _queue: [AnyMusicItem] = []
    
    /**
     Adds a music item to the end of the queue.
     
     - Parameter song: The music item to be added to the queue.
     */
    func enqueue(song: AnyMusicItem) {
        _queue.append(song)
        updated.toggle()
    }
    
    /**
     Removes and returns the first music item in the queue, if any.
     
     - Returns: The first music item in the queue, or nil if the queue is empty.
     */
    func dequeue() -> AnyMusicItem? {
        if _queue.isEmpty {
            return nil
        } else {
            updated.toggle()
            return _queue.removeFirst()
        }
    }
    
    /**
     Checks if the queue is empty.
     
     - Returns: A boolean value indicating whether the queue is empty or not.
     */
    var isEmpty: Bool {
        return _queue.isEmpty
    }
    
    /**
     Returns the first music item in the queue without removing it, if any.
     
     - Returns: The first music item in the queue, or nil if the queue is empty.
     */
    var front: AnyMusicItem? {
        return _queue.first
    }
    
    /**
     Returns an array containing all music items in the queue.
     
     - Returns: An array of AnyMusicItem objects representing all items in the queue.
     */
    func getQueueItems() -> [AnyMusicItem] {
        return _queue
    }
    
    /**
     Finds and returns a specific music item in the queue based on its ID.
     
     - Parameter id: The ID of the music item to be found.
     - Returns: The music item with the specified ID, or nil if not found.
     */
    func find(id: String) -> AnyMusicItem? {
        return _queue.first(where: { $0.id == id })
    }
    
    /**
     Removes a specific music item from the queue based on its ID.
     
     - Parameter id: The ID of the music item to be removed.
     */
    func removeItem(id: String) {
        if let index = _queue.firstIndex(where: { $0.id == id }) {
            _queue.remove(at: index)
        }
    }
    
    /**
     Sorts the queue based on the number of votes each music item has received.
     */
    private func sortQueue() {
        updated.toggle()
        _queue.sort { $0.votes > $1.votes }
    }
}
