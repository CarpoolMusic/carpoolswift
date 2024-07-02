//
//  Response.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-01.
//
import SocketIO

protocol ResponseProtocol {
    
}

struct CreateAccountResponse: ResponseProtocol, Codable {
    let userId: String
}

struct LoginResponse: ResponseProtocol, Codable {
    let accessToken: String
    let refreshToken: String
}

struct CreateSessionResponse: ResponseProtocol, Codable {
    let sessionId: String
}

struct JoinSessionResponse: ResponseProtocol, Codable {
    let users: [User]
}

struct User: Codable {
    let userId: String
}

struct AddSongResponse: ResponseProtocol, Codable {
    let song: SocketSong
}

struct LeaveSessionResponse: ResponseProtocol, Codable {
}

struct SocketConnectionResponse: ResponseProtocol, Codable {
    let status: Bool
}

struct ErrorResponse: ResponseProtocol, Codable {
    let type: String
    let message: String
    let stacktrace: String
}
