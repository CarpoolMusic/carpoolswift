//
//  MenuBarView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//

import SwiftUI

struct MenuBarView: View {
    
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        HStack {
            // Queue button.
            Button(action: handleQueueButtonPressed ) {
                Image(systemName: "line.horizontal.3")
                    .font(.largeTitle)
            }
            .padding()

            Spacer()
            
            // Chat button.
            Button(action: { /* Handle chat button action */ }) {
                Image(systemName: "bubble.right")
                    .font(.largeTitle)
            }
            .padding()
            
            Button(action: handleLeaveSessionButtonSelected) {
                Image(systemName: "arrow.turn.up.left")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            .padding()
        }
    }
    /// The action to perform when the user taps the Leave Session button.
    private func handleLeaveSessionButtonSelected() {
        do {
            try self.sessionManager.leaveSession()
        } catch {
            print("error leaving session")
        }
    }
    
    private func handleQueueButtonPressed() {
        self.sessionViewModel.isQueueOpen = true
        
    }
}
