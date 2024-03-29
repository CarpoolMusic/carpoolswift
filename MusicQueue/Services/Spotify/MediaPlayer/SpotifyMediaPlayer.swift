/**
 This class represents a Spotify media player that conforms to the `MediaPlayerProtocol` and `SPTAppRemotePlayerStateDelegate` protocols.
 
 ## Properties:
 - `logger`: An instance of the `Logger` class used for logging.
 - `appRemoteManager`: An instance of the `SpotifyAppRemoteManager` class used for managing the Spotify app remote.
 - `_playerQueue`: A generic `SongQueue` object that holds a queue of music items.
 - `playbackSet`: A boolean value indicating whether playback has been set or not.
 - `playerState`: An optional instance of the `SPTAppRemotePlayerState` class representing the current player state.
 - `currentEntryPublisher`: A publisher that emits the current music item being played.
 
 ## Methods:
 - `init(queue:)`: Initializes a new instance of the `SpotifyMediaPlayer` class with a given song queue.
 - `play()`: Plays the current song in the queue or resumes playback if already set.
 - `pause()`: Pauses playback.
 - `resume()`: Resumes playback.
 - `skipToNext()`: Skips to the next song in the queue and plays it.
 - `skipToPrevious()`: Skips to the previous song in the queue and plays it, or restarts the current song if no previous song exists.
 - `getPlayerState() -> PlayerState`: Returns the current player state (playing, paused, or undetermined).
 - `playerStateDidChange(_:)`: Called when the player state changes.

 */
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
    
    /**
     Initializes a new instance of the `SpotifyMediaPlayer` class with a given song queue.
     
     - Parameters:
        - queue: A `SongQueue` object representing the queue of music items.
     */
    init(queue: SongQueue<AnyMusicItem>) {
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
            logger.log(level: .error, "\(error.toString())")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
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
            logger.log(level: .info, "No next song in queue")
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
            logger.log(level: .info, "No previous entry. Restarting current.")
            appRemoteManager.appRemote.playerAPI?.play(currentSong.uri)
        } else {
            logger.log(level: .info, "No previous or current entry to play")
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
