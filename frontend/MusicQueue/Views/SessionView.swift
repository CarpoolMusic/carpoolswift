//
//  SessionView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI
import MusicKit

struct SessionView: View {
    
    // MARK: - Object lifecycle
        
    init(_ session: SessionManager) {
        self.session = session
    }
    
    // MARK: - Properties
    
    /// The session that this view represents.
    let session: SessionManager
    
    /// The songs that belong to this session.
    @State var songs: MusicItemCollection<Song>?
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Text("Session: \(session.sessionID)")
                .font(.title)
                .padding()
            
            // Add a list of songs on the session.
            if let loadedSongs = songs, !loadedSongs.isEmpty {
                Section(header: Text("Now Playing")) {
                    if let currentSong = loadedSongs.first {
                        VStack {
                            Text(currentSong.title)
                            if let artwork = currentSong.artwork {
                                ArtworkImage(artwork, width: 320)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            Button(action: handleLeaveSessionButtonSelected) {
                Text("Leave Session")
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .padding()
//        .navigationTitle(session.name)
        
        // When the view appears, load songs asynchronously.
        .task {
            try? await loadSongs()
        }
    }
    
    // MARK: - Loading songs
    
    /// Loads songs asynchronously.
    private func loadSongs() async throws {
//        let detailedSession = try await session.with([.songs])
//        update(songs: detailedSession.songs)
    }
    
    /// Safely updates `songs` property on the main thread.
    @MainActor
    private func update(songs: MusicItemCollection<Song>?) {
        withAnimation {
            self.songs = songs
        }
    }
    
    // MARK: - Playback
    
    /// The action to perform when the user taps the Leave Session button.
    private func handleLeaveSessionButtonSelected() {
        // Implement session leave logic here
    }
    
    /// The action to perform when the user taps a song in the list of songs.
    private func handleSongSelected(_ song: Song, loadedSongs: MusicItemCollection<Song>) {
        // Implement song selection logic here
    }
}

struct SessionView_Previews: PreviewProvider {
    let session: SessionManager
    static var previews: some View {
        SessionView(SessionManager())
    }
}

