//
//  NowPlayingView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-16.
//
import SwiftUI

struct NowPlayingView: View {
    
    let currentlyPlayingArt: UIImage?
    let albumArtPlaceholder = Image(systemName: "photo")
    
    // Get screen dimenesions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            albumArtPlaceholder
                .resizable()
                .frame(width: screenWidth * 0.85, height: screenHeight * 0.3)
                .clipped()
        }
    }
}
