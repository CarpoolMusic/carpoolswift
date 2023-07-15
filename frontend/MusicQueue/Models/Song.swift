//
//  Song.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-11.
//

struct Song {
    var id: String
    var title: String
    var artist: String
    var votes: Int
    
    init(id: String, title: String, artist: String, votes: Int) {
            self.id = id
            self.title = title
            self.artist = artist
            self.votes = votes
        }

    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.artist = dictionary["artist"] as? String ?? ""
        self.votes = dictionary["votes"] as? Int ?? 0
    }
}
