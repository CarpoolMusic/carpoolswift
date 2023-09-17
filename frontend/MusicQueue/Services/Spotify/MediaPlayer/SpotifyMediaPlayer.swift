//
//  SpotifyMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-15.
//
import MusicKit

class SpotifyMediaPlayer: NSObject, MediaPlayerProtocol {
    let appRemote: SPTAppRemote
    
    internal var playerState: SPTAppRemotePlayerState
    
    init(appRemote: SPTAppRemote) {
        self.appRemote = appRemote
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
                    print("This is the result from the callback")
                }
            }
        }
    }
    
    // MARK: - Player methods
    
    func play() {
        self.appRemote.playerAPI?.resume()
    }
    
    func playSong(song: Song) async throws {
        let trackUri = song.id.rawValue
        self.appRemote.playerAPI?.play(trackUri, callback: defaultCallback)
    }
    
    func pause() {
        self.appRemote.playerAPI?.pause()
    }
    
    func resume() {
        self.appRemote.playerAPI?.resume()
    }
    
    func togglePlayPause() async throws {
        self.playerState.isPaused ? self.play() : self.pause()
    }
    
    func skipToNext() {
        self.appRemote.playerAPI?.skip(toNext: defaultCallback)
    }
    
    func skipToPrevious() {
        self.appRemote.playerAPI?.skip(toPrevious: defaultCallback)
    }
    
    func getPlayerState() -> SPTAppRemotePlayerState {
        return self.playerState
    }
    
    func enqueueSong(song: Song) async throws {
        let trackUri = song.id.rawValue
        self.appRemote.playerAPI?.enqueueTrackUri(trackUri)
    }
    
    func getPlayerState() -> PlayerState {
        if self.playerState.isPaused {
            return PlayerState.paused
        }
        else {
            return PlayerState.playing
        }
    }
    
    func isPlaying() -> Bool {
        return !self.playerState.isPaused
    }
}
