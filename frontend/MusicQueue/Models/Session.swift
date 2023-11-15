//
//  Session.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import Foundation
import MusicKit

class Session {
    let id: String
    let hostId: String
    @Published var participants: [User] = []
    /// The song queue for this session
    @Published var queue: [any GenericSong] = []
//    {
//        didSet {
//            queue.sort {
//                $0.votes > $1.votes
//            }
//        }
//    }
    
    init(id: String, hostId: String) {
        self.id = id
        self.hostId = hostId
    }    
}
