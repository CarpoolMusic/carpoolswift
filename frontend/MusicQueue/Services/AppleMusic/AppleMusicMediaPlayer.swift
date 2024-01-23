//
//  AppleMusicMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import Foundation
import MusicKit
import Combine
import os

class AppleMusicMediaPlayer: MediaPlayerProtocol {
    let logger = Logger()

    private let _player: ApplicationMusicPlayer
    private var _userQueue: Queue
    private var isPlaybackQueueSet: Bool = false
    private var queueUpdate: AnyCancellable?
    
    var currentEntryPublisher: PassthroughSubject<AnyMusicItem, Never> = PassthroughSubject<AnyMusicItem, Never>()
    
    init(queue: Queue) {
        _player = ApplicationMusicPlayer.shared
        _player.queue = ApplicationMusicPlayer.Queue()
        _player.queue.entries = []
        self._userQueue = queue
        setupQueueUpdateSubscription()
    }
    
    private func setupQueueUpdateSubscription() {
        queueUpdate = _player.queue.objectWillChange
            .sink { [weak self] _ in
                if let currentEntry = self?._player.queue.currentEntry {
                    if case .song(let song) = currentEntry.item {
                        self?.currentEntryPublisher.send(AnyMusicItem(song))
                    }
                }
            }
    }
    
    // MARK: - Playback controls
    func play() {
        if (!isPlaybackQueueSet) {
            self.loadNextSong()
            isPlaybackQueueSet = true
        }
        
        performAsyncAction {
            try await self._player.play()
        }
    }
    
    func resume() {
        self.play()
    }
    
    func pause() {
        self._player.pause()
    }
    
    func togglePlayPause() {
        self.isPlaying() ? self.pause() : self.play()
    }

    func skipToNext() {
        self.loadNextSong()
        performAsyncAction {
            try await self._player.skipToNextEntry()
        }
    }

    func skipToPrevious() {
        performAsyncAction {
            try await self._player.skipToPreviousEntry()
        }
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
    
    private func enqueue(song: MusicKit.Song) -> Void {
        if (isPlaybackQueueSet) {
            performAsyncAction {
                try await self._player.queue.insert(song, position: .tail)
            }
        } else {
            let entry = MusicPlayer.Queue.Entry(song)
            _player.queue = ApplicationMusicPlayer.Queue([entry])
            isPlaybackQueueSet = true
        }
    }
    
    func loadNextSong() -> Void {
        do {
            guard let nextSong = _userQueue.dequeue() else {
                throw QueueUnderflowError(message: "No next song in queue", stacktrace: Thread.callStackSymbols)
            }
            
            let appleSong = try convertSongToBase(anyMusicItem: nextSong)
            enqueue(song: appleSong)
        } catch let error as QueueUnderflowError {
            logger.log(level: .error, "\(error)")
        } catch let error as SongConversionError {
            logger.log(level: .error, "\(error)")
        } catch {
            logger.log(level: .fault, "Unkown error \(error)")
            fatalError(error.localizedDescription)
        }
    }
    
    func currentSongTitle() -> String {
        return _player.queue.currentEntry?.title ?? "Untitled"
    }
    
    private func convertSongToBase(anyMusicItem: AnyMusicItem) throws -> MusicKit.Song {
        if case .appleSong(let song) = anyMusicItem.getBase() {
            return song
        }
        throw SongConversionError(message: "Unexpected base song type \(anyMusicItem.getBase()). Expected .appleSong", stacktrace: Thread.callStackSymbols)
    }
    
    private func performAsyncAction(_ action: @escaping () async throws -> Void) {
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
