//
//  SongCell.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-17.
//

import MusicKit
import SwiftUI

/// `SongCell` is a view to use in a SwiftUI `List` to represent a `Song`.
struct SongCell: View {
    
    // MARK: - Object lifecycle
    
    init(_ song: Song) {
        self.song = song
    }
    
    // MARK: - Properties
    
    let song: Song
    
    // MARK: - View
    
    var body: some View {
        NavigationLink(destination: SongDetailView(song)) {
            MusicItemCell(
                artwork: song.artwork,
                title: song.title,
                subtitle: song.artistName
            )
        }
    }
}
