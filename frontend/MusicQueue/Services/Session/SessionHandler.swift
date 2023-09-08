//
//  SessionHandler.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-07.
//
import SwiftUI

/// Responsible for session specific logic
class SessionHandler {
// MARK: - Session methods
    
    func isHost() -> Bool {
        return self.activeSession?.hostId == self.socketService.getSocketId()
    }
    
    func getNextSong() -> CustomSong? {
        if let nextSong = activeSession?.queue.first {
            self.lastSong = currentSong
            self.currentSong = nextSong
            // remove the song from the queue
            self.removeSongFromQueue(sessionId: self.activeSession?.id ?? "", songID: nextSong.id.rawValue)
        }
        return currentSong
    }
    
    func getLastSong() {
        
    }
    
}
    
