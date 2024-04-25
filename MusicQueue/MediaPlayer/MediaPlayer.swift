// MARK: - CodeAI Output
/**
 This code defines a MediaPlayer class that is responsible for controlling the playback of music. It uses the MusicKit framework and SwiftUI for the user interface.

 The PlayerState enum represents the possible states of the player: playing, paused, or undetermined.

 The MediaPlayerProtocol protocol defines the required methods and properties for a media player. It includes methods for playing, pausing, resuming, skipping to the next or previous track, and getting the current player state.

 The MediaPlayer class is an implementation of the MediaPlayerProtocol. It has a published property called currentEntry that represents the currently playing music item. It also has a private property called currentEntrySubscription that holds a subscription to receive updates on the current entry from the base media player.

 The init method of MediaPlayer takes a SongQueue parameter and initializes the base media player based on user preferences. It also sets up the currentEntrySubscription.

 The setupCurrentEntrySubscription method sets up a subscription to receive updates on the current entry from the base media player. When a new song is received, it updates the currentEntry property.

 The play method calls the play method of the base media player.

 The pause method calls the pause method of the base media player.

 The togglePlayPause method checks if the player is currently playing and calls either pause or play accordingly.

 The resume method calls the resume method of the base media player.

 The skipToNext method calls the skipToNext method of the base media player.

 The skipToPrevious method calls the skipToPrevious method of the base media player.

 The getPlayerState method returns th
*/
import SwiftUI
import MusicKit
import Combine

enum PlayerState {
    case playing
    case paused
    case undetermined
}

protocol MediaPlayerBaseProtocol{
    func play()
    func pause()
    func resume()
    func skipToNext()
    func skipToPrevious()
    func getPlayerState() -> PlayerState
}

protocol MediaPlayerProtocol: MediaPlayerBaseProtocol {
    func isPlaying() -> Bool
    func togglePlayPause()
}


class MediaPlayer: NSObject, MediaPlayerProtocol, ObservableObject {
    
    @Published var currentEntry: (SongProtocol)?
    
    private var currentEntrySubscription: AnyCancellable?
    
    private var base: MediaPlayerBaseProtocol?
    
    //MARK: - Music Controls
    
    func initializeBase(base: MediaPlayerBaseProtocol) {
        self.base = base
    }
    
    func play() {
        base?.play()
    }
    
    func pause() {
        base?.pause()
    }
    
    func togglePlayPause() {
        isPlaying() ? pause() : play()
    }
    
    func resume() { base?.resume() }
    
    func skipToNext() {
        base?.skipToNext()
    }
    
    func skipToPrevious() {
        base?.skipToPrevious()
   }

   func getPlayerState() -> PlayerState {
       return base?.getPlayerState() ?? .undetermined
   }

   func isPlaying() -> Bool {
       return getPlayerState() == .playing
   }
}
