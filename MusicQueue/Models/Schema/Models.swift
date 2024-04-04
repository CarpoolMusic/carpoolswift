//
//  Models.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-01.
//

protocol Model {
    func flatten() -> [String: Any]
}

struct Song: Model, Codable {
    let id: String
    let appleId: String
    let spotifyId: String
    let uri: String
    let title: String
    let artist: String
    let album: String
    let artworkUrl: String
    let votes: Int
    
    func flatten() -> [String: Any] {
        return [
            "id": id,
            "appleId": appleId,
            "spotifyId": spotifyId,
            "uri": uri,
            "title": title,
            "artist": artist,
            "album": album,
            "artworkUrl": artworkUrl,
            "votes": votes
        ]
    }
}

struct User: Model, Codable {
    let userId: String
    
    func flatten() -> [String : Any] {
        return [
            "userId": userId
        ]
    }
    
    
}
