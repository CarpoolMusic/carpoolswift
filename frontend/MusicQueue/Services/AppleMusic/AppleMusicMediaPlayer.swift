//
//  AppleMusicMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import Foundation
import MusicKit
import Combine

class AppleMusicMediaPlayer: MediaPlayerProtocol {

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
    func play() async throws {
        print("play")
        
        if (!isPlaybackQueueSet) {
            print("first play")
            try await loadNextSong()
            isPlaybackQueueSet = true
        }
        
        do {
            try await _player.play()
            print("Sucess on _player.play")
            print("CURRENT SONG PLAYING", _player.queue.currentEntry as Any)
        } catch {
            print("Failed to prepare play with error: \(error)")
        }
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
        print("skip to next")
        
        // Add next entry to player queue from user queue
        try await self.loadNextSong()
        do {
            try await _player.skipToNextEntry()
            print("success on skipToNextEntry")
            print("CURRENT SONG PLAYING", _player.queue.currentEntry as Any)
        } catch {
            print("Failed to skipToNextEntry with error \(error)")
        }
        print("loaded next song")
//        try await self.play()
    }

    func skipToPrevious() async throws {
        print("skip to previous")
        do {
            try await _player.skipToPreviousEntry()
            print("PREVIOUS", _player.queue.entries.first as Any)
            print("success on skipToPreviousEntry")
        } catch {
            print("Failed to skipToNextEntry with error \(error)")
        }
//        try await self.play()
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
    
    private func enqueue(song: MusicKit.Song) async throws -> Void {
        if (isPlaybackQueueSet) {
            do {
                try await _player.queue.insert(song, position: .tail)
                print("sucessfully added song to tail")
            } catch {
                print("Failed to insert into queue with error \(error)")
            }
        } else {
            let entry = MusicPlayer.Queue.Entry(song)
            _player.queue = ApplicationMusicPlayer.Queue([entry])
            print("entires in add", _player.queue.entries)
            isPlaybackQueueSet = true
        }
    }
    
    func loadNextSong() async throws -> Void {
        // add song to play if queue is empty
        if let song = convertSongToBase(anyMusicItem: _userQueue.dequeue()!) {
            // Add the next song to the queue
            try await enqueue(song: song)
        } else {
            print("Error getting song at front of queue.")
        }
    }
    
    func currentSongTitle() -> String {
        return _player.queue.currentEntry?.title ?? "Untitled"
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
