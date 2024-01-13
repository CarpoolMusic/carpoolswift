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
    func play() async throws -> Void
    func pause() async throws -> Void
    func resume() async throws -> Void
    func skipToNext() async throws -> Void
    func skipToPrevious() async throws -> Void
    func getPlayerState() -> PlayerState
}

class MediaPlayer: NSObject, ObservableObject {
    
    @Published var currentEntry: AnyMusicItem?
    private var currentEntrySubscription: AnyCancellable?
    
    
    /// Generic media player interface
    private let _base: MediaPlayerProtocol
    
    required init(queue: Queue) {
//        self._base = UserDefaults.standard.string(forKey: "musicServiceType") == "apple" ? AppleMusicMediaPlayer(queue: queue) : SpotifyMediaPlayer()
        print("init media player base to spotify")
        self._base = SpotifyMediaPlayer(queue: queue)
        
        super.init()
        
        setupCurrentEntrySub()
    }
    
    private func setupCurrentEntrySub() {
        currentEntrySubscription = _base.currentEntryPublisher
            .sink { [weak self] song in
                print("SETTING CURRENT ENTRY")
                self?.currentEntry = song
            }
    }
    
    //MARK: - Music Controls
    
    func play() async throws {
        print("PLAY")
        do {
            try await _base.play()
        } catch {
            print("Failed to skip to next with error \(error)")
        }
    }
    
    func pause() async throws {
        print("PAUSE")
        try await _base.pause()
    }
    
    func togglePlayPause() async throws {
        print("TOGGLE PLAY PAUSE")
        self.isPlaying() ? try await self.pause() : try await self.play()
    }
    
    func resume() async throws { try await _base.resume() }
    
    func skipToNext() async throws {
        print("SKIP TO NEXT")
        do {
            try await _base.skipToNext()
        } catch {
            print ("Failed to skip to next with error \(error)")
        }
    }
    
    func skipToPrevious() async throws {
        print("SKIP TO PREV")
        do {
            try await _base.skipToPrevious()
        } catch {
            print("Failed to skip prev with error \(error)")
        }
    }
    
    func getPlayerState() -> PlayerState {
        return _base.getPlayerState()
    }
    
    func isPlaying() -> Bool {
        return _base.getPlayerState() == .playing
    }
    
    /// Used in cases where async is not aloud and we need to call one of the media player methods (ex. in button action)
    func performAsyncAction(_ action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                // Handle error
                print("An error ocurred: \(error)")
            }
        }
    }
    
//    func setQueue(queue: Queue) {
//        self.mediaPlayer.setQueue(queue: queue)
//    }
}
