//
//  Requests.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-01.
//

protocol Request {
    func flatten() -> [String: Any]
}

// MARK: - Requests

struct CreateSessionRequest: Request, Codable {
    let hostId: String
    let sessionName: String
    
    func flatten() -> [String: Any] {
         return [
            "hostId": hostId,
            "sessionName": sessionName
         ]
    }
}

struct JoinSessionRequest: Request, Codable {
    let sessionId: String
    let hostName: String
    
    func flatten() -> [String: Any] {
        return [
            "sessionId": sessionId,
            "hostName": hostName
        ]
    }
}

struct LeaveSessionRequest: Request, Codable {
    let sessionId: String
    
    func flatten() -> [String: Any] {
        return [
            "sessionId": sessionId
        ]
    }
}

struct AddSongRequest: Request, Codable {
    let sessionId: String
    let song: Song
    
    func flatten() -> [String: Any] {
        return [
            "sessionId": sessionId,
            "song": song.flatten()
        ]
    }
}

struct RemoveSongRequest: Request, Codable {
    let sessionId: String
    let songId: String
    
    func flatten() -> [String: Any] {
        return [
            "sessionId": sessionId,
            "songId": songId
        ]
    }
}

struct VoteSongRequest: Request, Codable {
    let sessionId: String
    let songId: String
    let vote: Int
    
    func flatten() -> [String: Any] {
        return [
            "sessionId": sessionId,
            "songId": songId,
            "vote": vote
        ]
    }
}

