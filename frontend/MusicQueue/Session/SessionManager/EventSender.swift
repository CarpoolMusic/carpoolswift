//
//  EventSender.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-19.
//

import Foundation

extension SessionManager {
    
    func connect() {
        print("session manager connect")
        self.socketConnectionHandler.connect()
    }
    
    func disconnect() {
        print("session manager disconnect")
        self.socketConnectionHandler.disconnect()
    }
    
    func createSession(hostName: String, sessionName: String) throws {
        try self.socketEventSender.createSession(hostName: hostName, sessionName: sessionName)
    }
    
    func joinSession(sessionId: String, hostName: String) throws {
        try self.socketEventSender.joinSession(sessionId: sessionId, hostName: hostName)
    }
    
    func leaveSession() throws {
        try self.socketEventSender.leaveSession(sessionId: self._session.sessionId)
    }
    
    func addSong(song: AnyMusicItem) throws {
        try self.socketEventSender.addSong(sessionId: self._session.sessionId, song: song)
    }
    
    func voteSong(songId: String, vote: Int) throws {
        try self.socketEventSender.voteSong(sessionId: self._session.sessionId, songId: songId, vote: vote)
    }
}
