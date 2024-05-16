import SwiftUI
import MusicKit
import Combine

enum PlayerState {
    case playing
    case paused
    case undetermined
}

enum ScrubState {
    case reset
    case scrubStarted
    case scrubEnded(TimeInterval)
}

protocol MediaPlayerBaseProtocol{
    func play(song: SongProtocol)
    func pause()
    func resume()
    func restartCurrentEntry()
    func getPlayerState() -> PlayerState
    func seek(toTime: TimeInterval)
}

protocol MediaPlayerProtocol {
    var displayTime: Double { get set }
    var scrubState: ScrubState { get set }
    
    func play()
    func pause()
    func resume()
    func skipToNext()
    func skipToPrevious()
    func getPlayerState() -> PlayerState
    func isPlaying() -> Bool
    func togglePlayPause()
}


class MediaPlayer: NSObject, MediaPlayerProtocol, ObservableObject {
    @Injected private var userSettings: UserSettingsProtocol
    @Injected private var sessionManager: any SessionManagerProtocol
    
    @Published var playerState: PlayerState = .undetermined
    @Published var displayTime: Double = 0
    
    
    private var base: MediaPlayerBaseProtocol?
    private var playbackSet: Bool = false
    private var timer: Timer?
    var scrubState: ScrubState = .reset {
        didSet {
            switch scrubState {
            case .reset:
                if isPlaying() {
                    startTimer()
                }
                return
            case .scrubStarted:
                stopTimer()
            case .scrubEnded(let seekTime):
                seek(toTime: seekTime)
                displayTime = seekTime
                if isPlaying() {
                    startTimer()
                }
            }
        }
    }
    
    
    override init() {
        super.init()
        
        base = (userSettings.musicServiceType == .apple) ? AppleMusicMediaPlayer() : SpotifyMediaPlayer()
    }
    
    func seek(toTime: TimeInterval) {
        base?.seek(toTime: toTime)
    }
    
    func play() {
        if playbackSet {
            base?.resume()
        } else if let currentSong = sessionManager.activeSession?.queue.currentSong {
            base?.play(song: currentSong)
        }
        
        playerState = PlayerState.playing
        startTimer()
    }
    
    func pause() {
        base?.pause()
        stopTimer()
        playerState = PlayerState.paused
    }
    
    func resume() {
        base?.resume()
    }
    
    func skipToNext() {
        resetTimer()
        if ((sessionManager.activeSession?.queue.next()) != nil) {
            self.play()
        }
    }
    
    func skipToPrevious() {
        if displayTime > 3 {
            restartCurrentEntry()
            return
        }
        
        resetTimer()
        let _ = sessionManager.activeSession?.queue.previous()
        if isPlaying() {
            self.play()
            startTimer()
        }
    }
    
    func togglePlayPause() {
        isPlaying() ? pause() : play()
    }
    
    func restartCurrentEntry() {
        base?.restartCurrentEntry()
        resetTimer()
        if isPlaying() {
            startTimer()
        }
    }
    
    func getPlayerState() -> PlayerState {
        return base?.getPlayerState() ?? PlayerState.undetermined
    }
    
    func isPlaying() -> Bool {
        return getPlayerState() == .playing
    }
    
    private func startTimer() {
        timer?.invalidate()  // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying() else { return }
            DispatchQueue.main.async {
                self.displayTime += 1
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        stopTimer()
        displayTime = 0
    }
}
