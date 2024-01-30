//
//  MediaPlayer.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//

import SwiftUI
import MusicKit
import Combine

enum PlayerState {
    case playing
    case paused
    case undetermined
}

protocol MediaPlayerProtocol {
    var currentEntryPublisher: PassthroughSubject<AnyMusicItem, Never> { get }
    func play() -> Void
    func pause() -> Void
    func resume() -> Void
    func skipToNext() -> Void
    func skipToPrevious() -> Void
    func getPlayerState() -> PlayerState
}

class MediaPlayer: NSObject, ObservableObject {
    
    @Published var currentEntry: AnyMusicItem?
    private var currentEntrySubscription: AnyCancellable?
    
    
    private let _base: MediaPlayerProtocol
    
    required init(queue: SongQueue<AnyMusicItem>) {
        self._base = UserPreferences.getUserMusicService().rawValue == "apple" ? AppleMusicMediaPlayer(queue: queue) : SpotifyMediaPlayer(queue: queue)
        
        super.init()
        setupCurrentEntrySubscription()
    }
    
    private func setupCurrentEntrySubscription() {
        currentEntrySubscription = _base.currentEntryPublisher
            .sink { [weak self] song in
                self?.currentEntry = song
            }
    }
    
    //MARK: - Music Controls
    
    func play() {
        _base.play()
    }
    
    func pause() {
        _base.pause()
    }
    
    func togglePlayPause() {
        self.isPlaying() ? self.pause() : self.play()
    }
    
    func resume() { _base.resume() }
    
    func skipToNext() {
        _base.skipToNext()
    }
    
    func skipToPrevious() {
        _base.skipToPrevious()
    }
    
    func getPlayerState() -> PlayerState {
        return _base.getPlayerState()
    }
    
    func isPlaying() -> Bool {
        return _base.getPlayerState() == .playing
    }    
}
