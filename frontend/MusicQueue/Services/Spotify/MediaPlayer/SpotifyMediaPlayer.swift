//
//  SpotifyMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-15.
//
import SwiftUI
import MusicKit
import Combine
import os

class SpotifyMediaPlayer: NSObject, MediaPlayerProtocol, SPTAppRemotePlayerStateDelegate {
    let logger = Logger()
    
    private let appRemoteManager: SpotifyAppRemoteManager
    
    private var playbackSet: Bool = false
    private var playerState: SPTAppRemotePlayerState?
    private var _playerQueue: SongQueue<AnyMusicItem>
    
    var currentEntryPublisher: PassthroughSubject<AnyMusicItem, Never> = PassthroughSubject<AnyMusicItem, Never>()
    
    init(queue: SongQueue<AnyMusicItem>) {
        self._playerQueue = queue
        self.appRemoteManager = SpotifyAppRemoteManager()
    }
    
    // MARK: - Player methods
    
    func play() {
        if (playbackSet) {
            self.resume()
            return
        }
        
        do {
            guard let currentSong = _playerQueue.current else {
                throw MediaPlayerError(message: "No current song in queue", stacktrace: Thread.callStackSymbols)
            }
            
            appRemoteManager.connect(with: currentSong.uri)
            self.currentEntryPublisher.send(currentSong)
            playbackSet = true
            
        } catch let error as MediaPlayerError {
            logger.log(level: .error, "\(error.toString())")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
        }
    }
    
    func pause() {
        self.appRemoteManager.appRemote.playerAPI?.pause()
    }
    
    func resume() {
        self.appRemoteManager.appRemote.playerAPI?.resume()
    }
    
    func skipToNext() {
        guard let nextSong = _playerQueue.next() else {
            logger.log(level: .info, "No next song in queue")
            return
        }
        
        self.appRemoteManager.appRemote.playerAPI?.play(nextSong.uri)
        self.currentEntryPublisher.send(nextSong)
    }
    
    func skipToPrevious() {
        if let previousSong = _playerQueue.previous() {
            self.appRemoteManager.appRemote.playerAPI?.play(previousSong.uri)
            self.currentEntryPublisher.send(previousSong)
        } else if let currentSong = _playerQueue.current {
            logger.log(level: .info, "No previous entry. Restarting current.")
            self.appRemoteManager.appRemote.playerAPI?.play(currentSong.uri)
        } else {
            logger.log(level: .info, "No previous or current entry to play")
        }
    }
    
    func getPlayerState() -> PlayerState {
        guard let playerState = self.appRemoteManager.playerState else {
            return .undetermined
        }
        
        if (playerState.isPaused) {
            return .paused
        }
        return .playing
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("Player state has changed")
    }
}
