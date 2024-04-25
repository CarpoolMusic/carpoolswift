//
//  MediaPlayerEventPublisher.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-13.
//
import Foundation
import Combine

class MusicPlayerEventPublisher {
    static let shared = MusicPlayerEventPublisher()

    var currentSongChanged: PassthroughSubject<SongProtocol, Never> = PassthroughSubject<SongProtocol, Never>()
    var playerStateChanged: PassthroughSubject<PlayerState, Never> = PassthroughSubject<PlayerState, Never>()

    private var cancellables: Set<AnyCancellable> = []

    private init() {}

    func subscribeToMediaPlayerEvents(mediaPlayer: MediaPlayer) {
        
        NotificationCenter.default.publisher(for: .playerStateChangedNotification)
            .compactMap { $0.object as? PlayerState }
            .sink { [weak self] state in
                self?.playerStateChanged.send(state)
            }
            .store(in: &cancellables)
        
    }
}

extension Notification.Name {
    static let playerStateChangedNotification = Notification.Name("playerStateChangedNotification")
    static let currentSongChangedNotification = Notification.Name("currentSongChangedNotification")
}
