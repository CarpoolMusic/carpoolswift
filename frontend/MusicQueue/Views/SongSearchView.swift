//
//  SongSearchView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import SwiftUI

struct SongSearchView: View {
    
    @ObservedObject var viewModel = SongSearchViewModel(musicService: musicService)
    @State private var searchQuery: String = ""
    
    let onSelect: (Song) -> Void

    var body: some View {
        TextField("Search songs", text: $searchQuery)
            .onChange(of: searchQuery) { newValue in
                viewModel.searchSongs(query: newValue)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                List(viewModel.songs, id: \.id) { song in
                    Button(action: { onSelect(song) }) {
                        Text(song.title)
                    }
                }
            }
        }
    }
    
    /// A list of songs to display below the search bar.
    private var searchResultsList: some View {
        List(viewModel.songs.isEmpty ? recentAlbumsStorage.recentlyViewedAlbums : viewModel.songs) { album in
            AlbumCell(album)
        }
    }
}
