//
//  Session.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import Foundation

struct Session {
    let id: String
    var participants: [User] = []
    var queue: [Song] = []
}
