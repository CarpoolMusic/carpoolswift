import Foundation
import MusicKit
import MediaPlayer
import Combine
import os

class AppleMusicMediaPlayer: MediaPlayerProtocol {
    let logger = Logger()
    private let player: ApplicationMusicPlayer
    private var userQueue: SongQueue<AnyMusicItem>
    private var isPlaybackQueueSet = false
    private var queueUpdate: AnyCancellable?
    
    init(queue: SongQueue<AnyMusicItem>) {
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
            
            if !isPlaybackQueueSet, let song = getMusicKitSong(song: currentSong) {
                enqueue(song: song)
                NotificationCenter.default.post(name: .currentSongChangedNotification, object: currentSong)
            } else {
                print("Cannot get base song")
            }
            
            Task{
                try await player.play()
            }
        } catch let error as MediaPlayerError  {
            logger.log(level: .error, "\(error.toString())")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
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
    
    /// Toggles between play and pause states.
    func togglePlayPause() {
        isPlaying() ? pause() : play()
    }
    
    /// Skips to the next song in the queue.
    func skipToNext() {
        guard let nextSong = userQueue.next() else {
            logger.log("No next song in queue")
            return
        }
        
        do {
            guard let song = getMusicKitSong(song: nextSong) else {
                throw SongConversionError(message: "Error converting AnyMusicItem to MusicKit.Song for song \(nextSong)", stacktrace: Thread.callStackSymbols)
            }
            
            NotificationCenter.default.post(name: .currentSongChangedNotification, object: nextSong)
            enqueue(song: song)
            play()
            
        } catch let error as SongConversionError {
            logger.log(level: .error, "\(error.toString())")
        } catch {
            logger.log(level: .error, "\(error.localizedDescription)")
        }
    }
    
    /// Skips to the previous song in the queue.
    func skipToPrevious() {
        guard let previousSong = userQueue.previous() else {
            player.restartCurrentEntry()
            return
        }
        
        if let song = getMusicKitSong(song: previousSong) {
            NotificationCenter.default.post(name: .currentSongChangedNotification, object: previousSong)
            enqueue(song: song)
        }
        
        play()
    }
    
    private func enqueue(song: MusicKit.Song) {
        let entry = MusicPlayer.Queue.Entry(song)
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
    
    /// Returns a boolean indicating if the player is currently playing.
    func isPlaying() -> Bool {
        return getPlayerState() == .playing
    }
    
    /// Converts an AnyMusicItem to a MusicKit.Song.
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
