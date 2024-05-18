import SwiftUI

class SpotifyMediaPlayer: NSObject, MediaPlayerBaseProtocol, SPTAppRemotePlayerStateDelegate {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var appRemoteManager: SpotifyAppRemoteManagerProtocol
    
    override init() {
    }
    
    func play(song: SongProtocol) {
        if appRemoteManager.isConnected() {
            appRemoteManager.appRemote.playerAPI?.play(song.uri)
        } else {
            appRemoteManager.connect(with: song.uri)
        }
    }
    
    func pause() {
        appRemoteManager.appRemote.playerAPI?.pause()
    }
    
    func resume() {
        appRemoteManager.appRemote.playerAPI?.resume()
    }
    
    func restartCurrentEntry() {
        appRemoteManager.appRemote.playerAPI?.seek(toPosition: 0)
    }
    
    func getPlayerState() -> PlayerState {
        guard let playerState = appRemoteManager.playerState else {
            return .undetermined
        }
        
        if playerState.isPaused {
            return .paused
        }
        return .playing
    }
    
    func seek(toTime: TimeInterval) {
        let ms = Int(toTime) * 1000
        appRemoteManager.appRemote.playerAPI?.seek(toPosition: ms)
    }
    
    //unused
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
    }
    
}
