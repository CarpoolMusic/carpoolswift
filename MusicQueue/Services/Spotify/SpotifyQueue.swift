// MARK: - CodeAI Output
/**
 This class represents a generic song queue.
 
 The `SongQueue` class is a generic class that can hold elements of any type that conforms to the `Identifiable` protocol. It provides methods for managing and manipulating the queue.
 */
import os

class SongQueue<T: Identifiable>: ObservableObject {
    let logger = Logger()
    
    private var array: [T]
    private var currentIndex: Int
    
    /**
     Initializes an empty song queue.
     */
    init() {
        self.array = []
        self.currentIndex = 0
    }
    
    /**
     Returns the current element in the queue.
     
     - Returns: The current element in the queue, or `nil` if there is no current element.
     */
    var current: T? {
        guard array.indices.contains(currentIndex) else {
            logger.log(level: .debug, "No current element in queue.")
            return nil
        }
        return array[currentIndex]
    }
    
    /**
     Returns an array of all elements in the queue.
     
     - Returns: An array of all elements in the queue.
     */
    func getQueueItems() -> [T] {
        return array
    }
    
    /**
     Finds an element in the queue with the specified identifier.
     
     - Parameter id: The identifier of the element to find.
     
     - Returns: The first element with the specified identifier, or `nil` if no such element exists.
     */
    func find(id: String) -> T? {
        return array.first(where: { $0.id as! String == id })
    }
    
    /**
     Moves to the next element in the queue and returns it.
     
     - Returns: The next element in the queue, or `nil` if there is no next element.
     */
    func next() -> T? {
        guard !array.isEmpty, currentIndex < array.index(before: array.endIndex) else {
            logger.log(level: .debug, "No next element in queue.")
            return nil
        }
        
        currentIndex += 1
        return array[currentIndex]
    }
    
    /**
     Moves to the previous element in the queue and returns it.
     
     - Returns: The previous element in the queue, or `nil` if there is no previous element.
     */
    func previous() -> T? {
        guard !array.isEmpty, currentIndex > 0 else {
            logger.log(level: .debug, "No previous element in queue.")
            return nil
        }
        
        currentIndex -= 1
        return array[currentIndex]
    }
    
    /**
     Removes an element from the queue with the specified identifier.
     
     - Parameter id: The identifier of the element to remove.
     */
    func removeItem(id: String) {
        if let index = array.firstIndex(where: { $0.id as! String == id }) {
            array.remove(at: index)
        }
    }
    
    /**
     Resets the current index of the queue to zero.
     */
    func reset() {
        currentIndex = 0
    }
    
    /**
     Enqueues a new element to the end of the queue.
     
     - Parameter newElement: The new element to enqueue.
     */
    func enqueue(newElement: T) {
        array.append(newElement)
    }
}
