//
//  AppleMusicMediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import Foundation
import MusicKit
import MediaPlayer
import Combine
import os

class AppleMusicMediaPlayer: MediaPlayerProtocol {
    let logger = Logger()

    private let _player: ApplicationMusicPlayer
    private var _userQueue: SongQueue<AnyMusicItem>
    private var isPlaybackQueueSet: Bool = false
    private var queueUpdate: AnyCancellable?
    
    var currentEntryPublisher: PassthroughSubject<AnyMusicItem, Never> = PassthroughSubject<AnyMusicItem, Never>()
    
    init(queue: SongQueue<AnyMusicItem>) {
        _player = ApplicationMusicPlayer.shared
        self._userQueue = queue
    }
    
    // MARK: - Playback controls
    func play() {
        do {
            guard let currentSong = _userQueue.current else {
                throw MediaPlayerError(message: "No current song in queue", stacktrace: Thread.callStackSymbols)
            }
            
            if (!isPlaybackQueueSet) {
                if let song = getMusicKitSong(song: currentSong) {
                    enqueue(song: song)
                    currentEntryPublisher.send(currentSong)
                } else {
                    print("Cannot get base song")
                }
            }
            
            Task{
                try await self._player.play()
            }
        } catch let error as MediaPlayerError  {
            logger.log(level: .error, "\(error.toString())")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
        }
    }
    
    func resume() {
        Task {
            try await self._player.play()
        }
    }
    
    func pause() {
        self._player.pause()
    }
    
    func togglePlayPause() {
        self.isPlaying() ? self.pause() : self.play()
    }

    func skipToNext() {
        guard let nextSong = _userQueue.next() else {
            logger.log("No next song in queue")
            return
        }
        
        do {
            guard let song = getMusicKitSong(song: nextSong) else {
                throw SongConversionError(message: "Error converting AnyMusicItem to MusicKit.Song for song \(nextSong)", stacktrace: Thread.callStackSymbols)
            }
            
            self.currentEntryPublisher.send(nextSong)
            self.enqueue(song: song)
            self.play()
            
        } catch let error as SongConversionError {
            logger.log(level: .error, "\(error.toString())")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
        }
    }

    func skipToPrevious() {
        guard let previousSong = _userQueue.previous() else {
            self._player.restartCurrentEntry()
            return
        }
        if let song = getMusicKitSong(song: previousSong) {
            self.currentEntryPublisher.send(previousSong)
            self.enqueue(song: song)
        }
        self.play()
    }
    
    private func enqueue(song: MusicKit.Song) -> Void {
        let entry = MusicPlayer.Queue.Entry(song)
        self._player.queue = ApplicationMusicPlayer.Queue([entry])
        isPlaybackQueueSet = true
    }
    
    func getPlayerState() -> PlayerState {
        switch _player.state.playbackStatus {
        case .playing:
            return .playing
        case .paused:
            return .paused
        case .interrupted:
            return .paused
        default:
            return PlayerState.undetermined
        }
    }
    
    func isPlaying() -> Bool {
        return self.getPlayerState() == .playing
    }
    
    func getMusicKitSong(song: AnyMusicItem) -> MusicKit.Song? {
        switch song.getBase() {
        case .appleSong(let song):
            return song
        case .spotifySong:
            print("Wrong base")
            return nil
        }
    }
}
