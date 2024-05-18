import Foundation
import MusicKit
import MediaPlayer
import Combine
import os

class AppleMusicMediaPlayer: MediaPlayerBaseProtocol {
    @Injected private var logger: CustomLoggerProtocol
    
    private let player: ApplicationMusicPlayer
    private var queueUpdate: AnyCancellable?
    
    init() {
        player = ApplicationMusicPlayer.shared
    }
    
    func play(song: SongProtocol) {
        Task {
            enqueue(song: song)
            try await player.play()
        }
    }
    
    func resume() {
        Task {
            try await player.play()
        }
    }
    
    func restartCurrentEntry() {
        player.restartCurrentEntry()
    }
    
    func pause() {
        player.pause()
    }
    
    func seek(toTime: TimeInterval) {
        // The player does not currently have any sort of seek to method. Disabling this until we find a solution.
        //        player.seek(to: toTime)
    }
    
    
    private func enqueue(song: SongProtocol) {
        guard let musicItem = song as? AppleSong else {
            return
        }
        let entry = MusicPlayer.Queue.Entry(musicItem.getMusicKitBase())
        player.queue = ApplicationMusicPlayer.Queue([entry])
    }
    
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
