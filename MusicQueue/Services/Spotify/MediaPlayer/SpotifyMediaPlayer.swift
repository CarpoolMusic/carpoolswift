import SwiftUI
import MusicKit
import Combine
import os

class SpotifyMediaPlayer: NSObject, MediaPlayerBaseProtocol, SPTAppRemotePlayerStateDelegate {
    @Injected private var logger: CustomLoggerProtocol
    
    private let appRemoteManager: SpotifyAppRemoteManager
    
    private var playbackSet: Bool = false
    private var playerState: SPTAppRemotePlayerState?
    private var _playerQueue: SongQueue
    
    /**
     Initializes a new instance of the `SpotifyMediaPlayer` class with a given song queue.
     
     - Parameters:
        - queue: A `SongQueue` object representing the queue of music items.
     */
    init(queue: SongQueue) {
        self._playerQueue = queue
        self.appRemoteManager = SpotifyAppRemoteManager()
    }
    
    /**
     Plays the current song in the queue or resumes playback if already set.
     
     If there is no current song in the queue, it throws a `MediaPlayerError`.
     */
    func play() {
        if playbackSet {
            resume()
            return
        }
        
        do {
            guard let currentSong = _playerQueue.current else {
                throw MediaPlayerError(message: "No current song in queue", stacktrace: Thread.callStackSymbols)
            }
            
            appRemoteManager.connect(with: currentSong.uri)
            NotificationCenter.default.post(name: .sessionCreatedNotification, object: currentSong)
            playbackSet = true
            
        } catch let error as MediaPlayerError {
            logger.error("\(error.toString())")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    /**
     Pauses playback.
     */
    func pause() {
        appRemoteManager.appRemote.playerAPI?.pause()
    }
    
    /**
     Resumes playback.
     */
    func resume() {
        appRemoteManager.appRemote.playerAPI?.resume()
    }
    
    /**
     Skips to the next song in the queue and plays it.
     
     If there is no next song in the queue, it logs an info message.
     */
    func skipToNext() {
        guard let nextSong = _playerQueue.next() else {
            logger.info("No next song in queue")
            return
        }
        
        appRemoteManager.appRemote.playerAPI?.play(nextSong.uri)
        NotificationCenter.default.post(name: .sessionCreatedNotification, object: nextSong)
    }
    
    /**
     Skips to the previous song in the queue and plays it, or restarts the current song if no previous song exists.
     
     If there is no previous or current song in the queue, it logs an info message.
     */
    func skipToPrevious() {
        if let previousSong = _playerQueue.previous() {
            appRemoteManager.appRemote.playerAPI?.play(previousSong.uri)
            NotificationCenter.default.post(name: .sessionCreatedNotification, object: previousSong)
        } else if let currentSong = _playerQueue.current {
            logger.info("No previous entry. Restarting current.")
            appRemoteManager.appRemote.playerAPI?.play(currentSong.uri)
        } else {
            logger.info("No previous or current entry to play")
        }
    }
    
    /**
     Returns the current player state (playing, paused, or undetermined).
     
     - Returns: A `PlayerState` enum representing the current player state.
     */
    func getPlayerState() -> PlayerState {
        guard let playerState = appRemoteManager.playerState else {
            return .undetermined
        }
        
        if playerState.isPaused {
            return .paused
        }
        return .playing
    }
    
    /**
     Called when the player state changes.
     
     - Parameters:
        - playerState: An instance of `SPTAppRemotePlayerState` representing the new player state.
     */
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("Player state has changed")
    }
}
