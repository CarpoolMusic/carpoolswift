import Foundation
import MusicKit
import MediaPlayer
import Combine
import os

class AppleMusicMediaPlayer: MediaPlayerBaseProtocol {
    @Injected private var logger: CustomLoggerProtocol
    
    private let player: ApplicationMusicPlayer
    private var userQueue: SongQueue
    private var isPlaybackQueueSet = false
    private var queueUpdate: AnyCancellable?
    
    init(queue: SongQueue) {
        player = ApplicationMusicPlayer.shared
        userQueue = queue
    }
    
    // MARK: - Playback controls
    
    /// Starts playing the current song in the queue.
    func play() {
        do {
            guard let currentSong = userQueue.current else {
                throw MediaPlayerError(message: "No current song in queue", stacktrace: Thread.callStackSymbols)
            }
            
            if !isPlaybackQueueSet {
                enqueue(song: currentSong)
                NotificationCenter.default.post(name: .currentSongChangedNotification, object: currentSong)
            }
            
            Task{
                try await player.play()
            }
        } catch let error as MediaPlayerError  {
            logger.error("\(error.toString())")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    /// Resumes playback.
    func resume() {
        Task {
            try await player.play()
        }
    }
    
    /// Pauses playback.
    func pause() {
        player.pause()
    }
    
    /// Skips to the next song in the queue.
    func skipToNext() {
        guard let nextSong = userQueue.next() else {
            logger.error ("No next song in queue")
            return
        }
        
        do {
            NotificationCenter.default.post(name: .currentSongChangedNotification, object: nextSong)
            enqueue(song: nextSong)
            play()
        }
    }
    
    /// Skips to the previous song in the queue.
    func skipToPrevious() {
        guard let previousSong = userQueue.previous() else {
            player.restartCurrentEntry()
            return
        }
        
        NotificationCenter.default.post(name: .currentSongChangedNotification, object: previousSong)
        enqueue(song: previousSong)
        
        play()
    }
    
    private func enqueue(song: SongProtocol) {
        guard let musicItem = song as? AppleSong else {
            return
        }
        let entry = MusicPlayer.Queue.Entry(musicItem.getMusicKitBase())
        player.queue = ApplicationMusicPlayer.Queue([entry])
        isPlaybackQueueSet = true
    }
    
    /// Returns the current state of the player.
    func getPlayerState() -> PlayerState {
        switch player.state.playbackStatus {
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
}
