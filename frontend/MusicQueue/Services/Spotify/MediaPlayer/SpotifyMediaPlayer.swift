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
    
    private var playbackSet: Bool = false
    private var playerState: SPTAppRemotePlayerState?
    private var _playerQueue: SpotifySongQueue<AnyMusicItem>
    
    var currentEntryPublisher: PassthroughSubject<AnyMusicItem, Never> = PassthroughSubject<AnyMusicItem, Never>()
    
    init(queue: Queue) {
        self._userQueue = queue
        self._playerQueue = SpotifySongQueue()
        self.appRemoteManager = SpotifyAppRemoteManager()
    }
    
    // MARK: - Player methods
    
    func play() {
        print("play")
        
        if (playbackSet) {
            self.resume()
            return
        }
        
        loadNextSong()
        if let currentSong = _playerQueue.current {
            print("connecing with song", currentSong)
            appRemoteManager.connect(with: currentSong.uri)
            self.currentEntryPublisher.send(currentSong)
            playbackSet = true
        } else {
            print("No song in queue to play")
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
    
    func skipToNext() {
        print("skipToNext")
        loadNextSong()
        if let nextSong = _playerQueue.next() {
            self.appRemoteManager.appRemote.playerAPI?.play(nextSong.uri)
            self.currentEntryPublisher.send(nextSong)
        } else if let currentSong = _playerQueue.current {
            print("Unable to get next song. Restarting current.")
            self.appRemoteManager.appRemote.playerAPI?.play(currentSong.uri)
        } else {
            print("No previous or current song to play")
        }
    }
    
    func skipToPrevious() {
        print("skipToPrevious")
        if let previousSong = _playerQueue.previous() {
            self.appRemoteManager.appRemote.playerAPI?.play(previousSong.uri)
            self.currentEntryPublisher.send(previousSong)
        } else if let currentSong = _playerQueue.current {
            print("No previous song. Restarting current")
            self.appRemoteManager.appRemote.playerAPI?.play(currentSong.uri)
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
    
    func loadNextSong() -> Void {
        print("load next song")
        if let nextSong = _userQueue.dequeue() {
            self._playerQueue.append(newElement: nextSong)
        } else {
            print("Error getting song at front of queue")
        }
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("Player state has changed")
    }
}
