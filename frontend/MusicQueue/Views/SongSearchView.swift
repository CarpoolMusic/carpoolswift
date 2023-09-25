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
    
    var body: some View {
        List(musicService.songs.isEmpty ? [] : musicService.songs) { song in
            Button(action: {
                onSelect(song)
            }) {
                MusicItemCell(artworkURL: song.artworkURL, title: song.title, artist: song.artist)
            }
        }
        
        
        
        rootView
            .onChange(of: searchTerm) { newSearchTerm in
                musicService.requestUpdatedSearchResults(for: newSearchTerm)
            }
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
                .navigationTitle("Music Songs")
        }
        .searchable(text: $searchTerm, prompt: "Song")
    }
    
    /// A list of songs to display below the search bar.
    private var searchResultsList: some View {
    }
}

class SongSearchViewController {
    @State private var searchTerm: String = ""
    
}
