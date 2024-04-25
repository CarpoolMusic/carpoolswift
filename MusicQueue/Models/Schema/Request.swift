//
//  Requests.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-01.
//

protocol Request {
}

// MARK: - Requests

struct CreateSessionRequest: Request, Codable {
    let hostId: String
    let sessionName: String
    
    enum CodingKeys: String, CodingKey {
        case hostId, sessionName
    }
}

struct JoinSessionRequest: Request, Codable {
    let sessionId: String
    let hostName: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId, hostName
    }
}

struct LeaveSessionRequest: Request, Codable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId
    }
}

struct AddSongRequest: Request, Codable {
    let sessionId: String
    let song: SocketSong
    
    enum CodingKeys: String, CodingKey {
        case sessionId, song
    }
}

struct RemoveSongRequest: Request, Codable {
    let sessionId: String
    let songId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId, songId
    }
}

struct VoteSongRequest: Request, Codable {
    let sessionId: String
    let songId: String
    let vote: Int
    
    enum CodingKeys: String, CodingKey {
        case sessionId, songId, vote
    }
}

