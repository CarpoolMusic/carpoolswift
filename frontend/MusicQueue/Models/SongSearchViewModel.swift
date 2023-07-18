//
//  SongSearchViewModel.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import SwiftUI
import MusicKit

class SongSearchViewModel: ObservableObject {
   
    private let musicService: AnyMusicService
    
    @Published var songs: MusicItemCollection<Song> = []
    
    init(musicService: AnyMusicService) {
        self.musicService = musicService
    }
    
    func searchSongs(query: String) {
        Task {
            if query.isEmpty {
                self.songs = []
            } else {
                do {
                    let songSearchResults = try await self.musicService.searchSongs(query: query)
                    DispatchQueue.main.async {
                        self.songs = songSearchResults
                    }
                } catch {
                    print("Search request failed with error: \(error).")
                    self.songs = []
                }
            }
        }
    }
}
