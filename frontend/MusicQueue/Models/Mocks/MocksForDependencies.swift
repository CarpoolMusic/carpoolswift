//
//  MocksForDependencies.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-02-19.
//

import Foundation

// Assuming MediaPlayer is a class you've defined; here's a basic mock for preview purposes
class MockMediaPlayer: MediaPlayer {
    override func isPlaying() -> Bool {
        return false // Return a default value for previewing
    }
    
    // Implement other necessary methods as stubs or with mock behavior
    override func togglePlayPause() {}
    override func skipToPrevious() {}
    override func skipToNext() {}
}

class MockSongQueue: SongQueue<AnyMusicItem> {
    
}

class MockSessionManager: SessionManager {
    
}
