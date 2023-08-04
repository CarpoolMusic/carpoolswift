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
        self.artworkURL = (musicKitSong.artwork?.url(width: 10, height: 10)!)!
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
