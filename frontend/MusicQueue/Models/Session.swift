//
//  Session.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import Foundation
import MusicKit

struct Session {
    let id: String
    var participants: [User] = []
    /// The song queue for this session
    var queue: [CustomSong] = [
//        Song(id: "1", title: "Imagine", artist: "John Lennon", votes: 3),
//        Song(id: "2", title: "Hey Jude", artist: "The Beatles", votes: 5),
//        Song(id: "3", title: "Bohemian Rhapsody", artist: "Queen", votes: 2),
//        Song(id: "4", title: "Stairway to Heaven", artist: "Led Zeppelin", votes: 6)
    ] {
        didSet {
            queue.sort {
                $0.votes > $1.votes
            }
        }
    }
}
