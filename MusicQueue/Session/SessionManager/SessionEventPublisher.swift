//
//  SessionEventPublisher.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-12.
//

import Foundation

import Combine
import Foundation


class SessionEventPublisher {
    static let shared = SessionEventPublisher()
    
    private var cancellables = Set<AnyCancellable>()
    
    // Publishers
    let sessionCreated = PassthroughSubject<Bool, CustomError>()
    let sessionJoined = PassthroughSubject<[String], Never>()
    let songAdded = PassthroughSubject<AnyMusicItem, CustomError>()
    let songRemoved = PassthroughSubject<String, Never>()
    let songVoted = PassthroughSubject<(songId: String, vote: Int), Never>()
}

extension Notification.Name {
    // Define other notifications similarly
}
