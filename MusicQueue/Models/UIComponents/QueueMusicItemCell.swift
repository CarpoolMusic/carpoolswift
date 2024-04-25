//
//  QueueMusicItemCell.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-12.
//

import Foundation
import SwiftUI

struct QueueMusicItemCell: View {
    let song: SongProtocol
    private var sessionManager: SessionManager
    @State private var thumbsUpPressed = false
    @State private var thumbsDownPressed = false
    
    init(song: SongProtocol, sessionManager: SessionManager) {
        self.song = song
        self.sessionManager = sessionManager
    }
    
    var body: some View {
        VStack {
            BaseMusicItemCell(song: song)
                .padding(.horizontal)
            
            HStack {
                ThumbsButton(imageName: thumbsUpPressed ? "hand.thumbsup.fill" : "hand.thumbsup", color: .blue, action: {
                    thumbsUpPressed.toggle()
                    thumbsDownPressed = false
                    // Voting logic here
                })
                
                Spacer()
                
                ThumbsButton(imageName: thumbsDownPressed ? "hand.thumbsdown.fill" : "hand.thumbsdown", color: .red, action: {
                    thumbsDownPressed.toggle()
                    thumbsUpPressed = false
                    // Voting logic here
                })
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct ThumbsButton: View {
    let imageName: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .foregroundColor(color)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
