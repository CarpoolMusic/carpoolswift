//
//  SpotifyQueue.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-15.
//

struct SpotifySongQueue<T> {
    private var array: [T]
    private var currentIndex: Int

    init() {
        self.array = []
        self.currentIndex = array.startIndex
        print("STSRT IDX \(array.startIndex)")
    }

    var current: T? {
        return array.indices.contains(currentIndex) ? array[currentIndex] : nil
    }
    
    mutating func next() -> T? {
        guard !array.isEmpty, currentIndex < array.index(before: array.endIndex) else {
            return nil
        }
        currentIndex = array.index(after: currentIndex)
        return array[currentIndex]
    }

    mutating func previous() -> T? {
        guard !array.isEmpty, currentIndex > array.startIndex else {
            return nil
        }
        currentIndex = array.index(before: currentIndex)
        return array[currentIndex]
    }

    mutating func reset() {
        currentIndex = array.startIndex
    }
    
    mutating func append(newElement: T) {
        array.append(newElement)
    }
}
