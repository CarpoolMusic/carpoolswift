//
//  SpotifyMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-15.
//
import SwiftUI
import MusicKit
import Combine

class SpotifyMediaPlayer: NSObject, MediaPlayerProtocol {
    
    
    var currentEntryPublisher = PassthroughSubject<AnyMusicItem, Never>()
    
    
    func currentSongArtworkUrl(width: Int, height: Int) -> URL? {
        return nil
    }
    
    func setQueue(queue: Queue) {
        print("nothing")
    }
    
    let appRemoteManager: SpotifyAppRemoteManager
    let appRemote: SPTAppRemote
    var isPaused: Bool = true
    
    override init() {
        self.appRemoteManager = SpotifyAppRemoteManager()
        self.appRemote = appRemoteManager.appRemote
        /// subsribe to changes from the player state
        self.appRemote.playerAPI?.subscribe()
    }
    
    
    /// result and error returned from the player
    /// on success result will carry desrired value from call
    /// on error resilt will be nil and error set
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {result, error in
                if let error = error {
                    print("There has been an error")
                }
                else {
                    print("This is the result from the callback \(String(describing: result))")
                }
            }
        }
    }
    
    // MARK: - Player methods
    
    func play() {
        self.appRemote.playerAPI?.resume()
    }
    
    func playSong(song: AnyMusicItem) async throws {
//        let trackUri = song.id
//        self.appRemote.playerAPI?.play(trackUri.rawValue, callback: defaultCallback)
    }
    
    func pause() {
        self.appRemote.playerAPI?.pause()
    }
    
    func resume() {
        self.appRemote.playerAPI?.resume()
    }
    
    func togglePlayPause() async throws {
        self.appRemote.playerAPI?.getPlayerState({playerState, error in
            if let error = error {
                print("There has been an error \(error)")
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                playerState.isPaused ? self.play() : self.pause()
            }
        })
    }
    
    func skipToNext() {
        self.appRemote.playerAPI?.skip(toNext: defaultCallback)
    }
    
    func skipToPrevious() {
        self.appRemote.playerAPI?.skip(toPrevious: defaultCallback)
    }
    
    func enqueueSong(song: AnyMusicItem) async throws {
//        let trackUri = song.id
//        self.appRemote.playerAPI?.enqueueTrackUri(trackUri.rawValue)
    }
    
    func getPlayerState() -> PlayerState {
//        if self.playerState.isPaused {
//            return PlayerState.paused
//        }
//        else {
//            return PlayerState.playing
//        }
        return PlayerState.undetermined
    }
    
    func queueIsEmpty() -> Bool {
        return false
    }
    
    func currentSongLoaded() -> Bool {
        return false
    }
    
    func isPlaying() -> Bool {
//        return !self.playerState.isPaused
        return false
    }
}
