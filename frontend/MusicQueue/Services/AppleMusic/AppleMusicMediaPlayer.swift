//
//  AppleMusicMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import Foundation
import MusicKit

class AppleMusicMediaPlayer: MediaPlayerProtocol {
    private let _player: ApplicationMusicPlayer
    private var _userQueue: Queue
    
    private var isPlaybackQueueSet = false
    
    init(queue: Queue) {
        self._player = ApplicationMusicPlayer.shared
        self._userQueue = queue
    }

    // MARK: - Playback controls
    func play() async throws {
        print("PLAY() song pressed")
        
        if (self._player.queue.currentEntry == nil) {
            try await loadNextSong()
        }
        self.preparePlayer()
        try await _player.play()
    }
    
    func currentSongArtworkUrl() async throws -> URL? {
        print("LOADING SONG IMAGE")
        if (self._player.queue.currentEntry == nil) {
            try await loadNextSong()
        }
        
        return self._player.queue.currentEntry?.artwork?.url(width: 40, height: 40)
    }
    
    func resume() async throws {
        try await self.play()
    }
    
    func pause() async throws {
        self._player.pause()
    }
    
    func togglePlayPause() async throws {
        print("Toggle play pause")
        try await self.isPlaying() ? self.pause() : self.play()
    }

    func skipToNext() async throws {
        // add next entry to player queue from user queue
        try await self.loadNextSong()
        try await self._player.skipToNextEntry()
        try await self.play()
    }

    func skipToPrevious() async throws {
        print("entires", _player.queue.entries)
        try await _player.skipToPreviousEntry()
        try await self.play()
    }
    
    func getPlayerState() -> PlayerState {
        switch _player.state.playbackStatus {
        case .playing:
            return PlayerState.playing
        case .paused:
            return PlayerState.paused
        default:
            return PlayerState.undetermined
        }
    }
    
    func isPlaying() -> Bool {
        return self._player.state.playbackStatus == .playing
    }
    
    func loadNextSong() async throws -> Void {
        // add song to play if queue is empty
        if let nextSong = _userQueue.dequeue(), let song = convertSongToBase(anyMusicItem: nextSong) {
            if (!self.isPlaybackQueueSet) {
                self._player.queue = [song]
                self.isPlaybackQueueSet = true
            } else {
                try await self._player.queue.insert(song, position: .tail)
                print("entires", self._player.queue.entries)
            }
        } else {
            print("Error getting song at front of queue.")
        }
    }
    
    func preparePlayer() -> Void {
        Task {
            try await _player.prepareToPlay()
        }
    }
    
    private func convertSongToBase(anyMusicItem: AnyMusicItem) -> MusicKit.Song? {
        switch anyMusicItem.getBase() {
        case .appleSong(let song):
            return song
        default:
            print("error")
        }
        
        print("failed to convert song to mussickit.song")
        return nil
    }    
}
