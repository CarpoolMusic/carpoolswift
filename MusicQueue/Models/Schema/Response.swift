//
//  Response.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-01.
//

protocol Response {
    
}

struct CreateSessionResponse: Response, Codable {
    let sessionId: String
}

struct JoinSessionResponse: Response, Codable {
}

struct LeaveSessionResponse: Response, Codable {
}
