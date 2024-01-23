//
//  SpotifyQueue.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-15.
//
import os

struct SpotifySongQueue<T> {
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
    
    mutating func next() -> T? {
        guard !array.isEmpty, currentIndex < array.index(before: array.endIndex) else {
            logger.log(level: .debug, "No next element in queue.")
            return nil
        }
        currentIndex = array.index(after: currentIndex)
        return array[currentIndex]
    }

    mutating func previous() -> T? {
        guard !array.isEmpty, currentIndex > array.startIndex else {
            logger.log(level: .debug, "No next element in queue.")
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
