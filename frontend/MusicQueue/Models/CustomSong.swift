//
//  CustomSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-11.
//

import MusicKit

struct CustomSong: MusicItem, Equatable, Identifiable {
    var id: MusicItemID
    
    var title: String
    var artworkURL: URL
    var artist: String
    var votes: Int
    
    // Initialize with a MusicKit's Song data
    init(musicKitSong: Song) {
        self.id = musicKitSong.id
        self.title = musicKitSong.title
        self.artworkURL = (musicKitSong.artwork?.url(width: 100, height: 100)!)!
        self.artist = musicKitSong.artistName
        self.votes = 0 // You would need to determine how to set votes, as it doesn't exist in the Song object
    }
    
    // Initialize with a SpotifyTrack Song data
    init(spotifyTrack: SpotifyTrack) {
        self.id = MusicItemID(spotifyTrack.id)
        self.title = spotifyTrack.name
        self.artworkURL = URL(string: spotifyTrack.artworkURL)!
        self.artist = spotifyTrack.artistName
        self.votes = 0
    }
    
    init?(dictionary: [String: Any]) {
        guard let idString = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let artworkURLString = dictionary["artworkURL"] as? String,
              let artworkURL = URL(string: artworkURLString),
              let artist = dictionary["artist"] as? String,
              let votes = dictionary["votes"] as? Int
        else {
            return nil
        }

        self.id = MusicItemID(idString)
        self.title = title
        self.artworkURL = artworkURL
        self.artist = artist
        self.votes = votes
    }

    
    /// Converts the song object into a dictionary with its basic info
    func toDictionary() -> [String: Any] {
        return [
            "id": id.rawValue,
            "title": title,
            "artworkURL": artworkURL.absoluteString,
            "artist": artist,
            "votes": votes
        ]
    }
}
