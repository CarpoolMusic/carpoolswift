//
//  MediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import MusicKit

enum PlayerState {
    case playing
    case paused
    case undetermined
}

protocol MediaPlayerProtocol {
    func play() async throws -> Void
    func playSong(song: Song) async throws -> Void
    func pause() async throws -> Void
    func resume() async throws -> Void
    func togglePlayPause() async throws -> Void
    func skipToNext() async throws -> Void
    func skipToPrevious() async throws -> Void
    func enqueueSong(song: Song) async throws -> Void
    func getPlayerState() -> PlayerState
    func isPlaying() -> Bool
}

class MediaPlayer: NSObject, MediaPlayerProtocol {
    
    private let mediaPlayer: MediaPlayerProtocol
    
    init(with mediaPlayer: MediaPlayerProtocol) {
        self.mediaPlayer = mediaPlayer
    }
    
    //MARK: - Music Controls
    
    func play() async throws {
        try await mediaPlayer.play()
    }
    
    func pause() async throws {
        try await mediaPlayer.pause()
    }
    
    func togglePlayPause() async throws {
        if mediaPlayer.getPlayerState() == .paused {
            try await mediaPlayer.play()
        } else {
            try await mediaPlayer.pause()
        }
    }
    
    func playSong(song: Song) async throws {
        try await mediaPlayer.playSong(song: song)
    }

    func resume() async throws {
        try await mediaPlayer.resume()
    }
    
    func skipToNext() async throws {
        try await mediaPlayer.skipToNext()
    }
    
    func skipToPrevious() async throws {
        try await mediaPlayer.skipToPrevious()
    }
    
    func enqueueSong(song: Song) async throws {
        try await mediaPlayer.enqueueSong(song: song)
    }
    
    func getQueueItems() -> Array<Song> {
        return mediaPlayer.getQueueItems()
    }
    
    func getPlayerState() -> PlayerState {
        return mediaPlayer.getPlayerState()
    }
    
    func isPlaying() -> Bool {
        return self.mediaPlayer.isPlaying()
    }
    
    /// Used in cases where async is not aloud and we need to call one of the media player methods (ex. in button action)
    func performMediaPlayerAction(_ action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                // Handle error
                print("An error ocurred: \(error)")
            }
        }
    }
}
