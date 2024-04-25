//
//  SearchMusicItemCell.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-12.
//

import Foundation
import SwiftUI

struct SearchMusicItemCell: View {
    var song: SongProtocol
    var songInQueue: Binding<Bool>
    var onAddToQueue: () -> Void
    
    @State var cellTapped: Bool
    
    var body: some View {
        HStack {
            BaseMusicItemCell(song: song)
            
            Spacer()
            
            if songInQueue.wrappedValue || cellTapped {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Button(action: {
                    onAddToQueue()
                    cellTapped = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.horizontal, 10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
