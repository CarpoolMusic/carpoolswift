//
//  SongSearchView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import SwiftUI
import MusicKit
import MusicKit

struct SongSearchView: View {
    
  
    @ObservedObject var musicService: AnyMusicService
    
    
    let onSelect: (Song) -> Void
    
    var body: some View {
        rootView
    }
    
    // The various components of the main navigation view.
    private var navigationViewContents: some View {
        VStack {
            searchResultsList
                .animation(.default, value: musicService.songs)
            }
    }
    
    /// The top-level content view.
    private var rootView: some View {
        NavigationView {
            navigationViewContents
                .navigationTitle("Music Albums")
        }
        .searchable(text: $musicService.searchTerm, prompt: "Albums")
    }
    
    /// A list of songs to display below the search bar.
    private var searchResultsList: some View {
        List(musicService.songs.isEmpty ? [] : musicService.songs) { song in
            MusicItemCell(artwork: song.artwork, title: song.title)
        }
    }
}
