//
//  SpotifyMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-15.
//
import SwiftUI
import MusicKit
import Combine

class SpotifyMediaPlayer: NSObject, MediaPlayerProtocol, SPTAppRemotePlayerStateDelegate {
    private let _userQueue: Queue
    private let appRemoteManager: SpotifyAppRemoteManager
    
    private var isPlaybackQueueSet: Bool = false
    private var playerState: SPTAppRemotePlayerState?
    private var _playerQueue: SpotifySongQueue<String>
    
    var currentEntryPublisher: PassthroughSubject<AnyMusicItem, Never> = PassthroughSubject<AnyMusicItem, Never>()
    
    init(queue: Queue) {
        self._userQueue = queue
        self._playerQueue = SpotifySongQueue()
        self.appRemoteManager = SpotifyAppRemoteManager()
    }
    
    // MARK: - Player methods
    
    func play() async throws {
        print("play")
        
        if (!isPlaybackQueueSet) {
            try await loadNextSong()
            if let currentSong = _playerQueue.current {
                print("connecing with song", currentSong)
                appRemoteManager.connect(with: currentSong)
                isPlaybackQueueSet = true
            } else {
                print("No song in queue to play")
            }
        } else {
            self.resume()
        }
        
    }
    
    func pause() {
        print("pause")
        self.appRemoteManager.appRemote.playerAPI?.pause()
    }
    
    func resume() {
        print("resume")
        self.appRemoteManager.appRemote.playerAPI?.resume()
    }
    
    func skipToNext() async throws {
        print("skipToNext")
        try await loadNextSong()
        if let nextSongUri = _playerQueue.next() {
            appRemoteManager.appRemote.playerAPI?.play(nextSongUri)
        } else if let currentSong = _playerQueue.current {
            print("Unable to get next song. Restarting current.")
            self.appRemoteManager.appRemote.playerAPI?.play(currentSong)
        } else {
            print("No previous or current song to play")
        }
    }
    
    func skipToPrevious() {
        print("skipToPrevious")
        if let previousSong = _playerQueue.previous() {
            self.appRemoteManager.appRemote.playerAPI?.play(previousSong)
        } else if let currentSong = _playerQueue.current {
            print("No previous song. Restarting current")
            self.appRemoteManager.appRemote.playerAPI?.play(currentSong)
        } else {
            print("No previous or current song to play.")
        }
    }
    
    func getPlayerState() -> PlayerState {
        guard let playerState = self.appRemoteManager.playerState else {
            return .undetermined
        }
        print("Player state \(playerState)")
        if (playerState.isPaused) {
            return .paused
        } else {
            return .playing
        }
    }
    
    func loadNextSong() async throws -> Void {
        print("load next song")
        if let nextSong = _userQueue.dequeue() {
            // Add next song uri to the player queue
            self._playerQueue.append(newElement: nextSong.uri)
        } else {
            print("Error getting song at front of queue")
        }
    }
    
    func handlePlayerCallback<T>(result: T?, error: Error?) {
        if let result = result {
            print("good \(result)")
        } else {
            print("Error in callback from media player \(String(describing: error?.localizedDescription))")
        }
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("Player state has changed")
    }
}

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
