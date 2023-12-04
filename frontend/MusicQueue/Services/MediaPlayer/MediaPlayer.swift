//
//  MediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//

import SwiftUI
import MusicKit

enum PlayerState {
    case playing
    case paused
    case undetermined
}

protocol MediaPlayerProtocol {
    func play() async throws -> Void
    func pause() async throws -> Void
    func resume() async throws -> Void
    func togglePlayPause() async throws -> Void
    func skipToNext() async throws -> Void
    func skipToPrevious() async throws -> Void
    func getPlayerState() -> PlayerState
    func currentSongArtworkUrl() async throws -> URL?
    func isPlaying() -> Bool
}

class MediaPlayer: NSObject, MediaPlayerProtocol, ObservableObject {
    
    @Published var newCurrentSong: Bool = false
    
    /// Generic media player interface
    private let _base: MediaPlayerProtocol
    
    required init(queue: Queue) {
//        self._base = UserDefaults.standard.string(forKey: "musicServiceType") == "apple" ? AppleMusicMediaPlayer(queue: queue) : SpotifyMediaPlayer()
        print("init media player base to apple")
        self._base = AppleMusicMediaPlayer(queue: queue)
    }
    
    //MARK: - Music Controls
    
    func play() async throws {
        print("PLAY")
        try await _base.play()
    }
    
    func pause() async throws {
        print("PAUSE")
        try await _base.pause()
    }
    
    func togglePlayPause() async throws {
        print("TOGGLE PLAY PAUSE")
        if _base.getPlayerState() != .playing {
            try await self.play()
        } else {
            try await self.pause()
        }
    }
    
    func resume() async throws { try await _base.resume() }
    
    func skipToNext() async throws {
        print("SKIP TO NEXT")
        try await _base.skipToNext()
        DispatchQueue.main.async {
            self.newCurrentSong.toggle()
            print("SET NEW CURRENT SON")
        }
    }
    
    func skipToPrevious() async throws {
        print("SKIP TO PREV")
        try await _base.skipToPrevious()
        DispatchQueue.main.async {
            print("SET NEW CURRENT SON")
            self.newCurrentSong.toggle()
        }
    }
    
    func getPlayerState() -> PlayerState {
        return _base.getPlayerState()
    }
    
    func isPlaying() -> Bool {
        return self._base.isPlaying()
    }
    
    func currentSongArtworkUrl() async throws -> URL? {
        print("mediaPlayer.currentSongArtworkURl")
        return try await self._base.currentSongArtworkUrl()
    }
    
    /// Used in cases where async is not aloud and we need to call one of the media player methods (ex. in button action)
    func performAsyncAction(_ action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                // Handle error
                print("An error ocurred: \(error)")
            }
        }
    }
    
//    func setQueue(queue: Queue) {
//        self.mediaPlayer.setQueue(queue: queue)
//    }
}
