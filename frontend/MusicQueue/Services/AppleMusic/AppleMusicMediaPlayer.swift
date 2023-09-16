//
//  AppleMusicMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import MusicKit

class AppleMusicMediaPlayer: MediaPlayerProtocol {
    private let player: SystemMusicPlayer
    private let queue: MusicPlayer.Queue

    init() {
        self.player = SystemMusicPlayer.shared
        self.queue = MusicPlayer.Queue()
    }

    // MARK: - Playback controls
    func play() async throws {
        try await prepareToPlay()
        if self.player.isPreparedToPlay {
            try await player.play()
        }
    }
    
    func playSong(song: Song) async throws {
        try await self.queue.insert(song, position: .afterCurrentEntry)
        try await self.player.skipToNextEntry()
        try await self.play()
    }
    
    func resume() async throws {
        try await self.play()
    }
    
    func pause() async throws {
        self.player.pause()
    }

    func skipToNext() async throws {
        try await self.player.skipToNextEntry()
    }

    func skipToPrevious() async throws {
        try await self.player.skipToPreviousEntry()
    }
    
    func enqueueSong(song: Song) async throws {
        try await self.queue.insert(song, position: .tail)
    }
    
    func getPlayerState() -> PlayerState {
        switch player.state.playbackStatus {
        case .playing:
            return PlayerState.playing
        case .paused:
            return PlayerState.paused
        default:
            return PlayerState.undetermined
        }
    }

    /// Prepares the current queue for playback, interrupting any active (nonmixable) audio sessions.
    private func prepareToPlay() async throws {
        try await self.player.prepareToPlay()
    }    
}
