// MARK: - CodeAI Output
/**
 This code represents the view for a session in an app. It displays various components such as a title, now playing information, audio controls, and a menu bar. It also includes functionality for handling button presses and managing the session.
 */

import SwiftUI
import Combine

struct NowPlayingView: View {
    @State private var showingQueue: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                AlbumArtView()
                
                AudioControlView(isHost: true)
                    .padding(.top, 20)
            }
            .blur(radius: showingQueue ? 3 : 0)
            .disabled(showingQueue)
            .padding()
        
            if showingQueue {
                SessionQueueView()
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
            
            VStack {
                Spacer()
                
                PlayerControlView(showingQueue: $showingQueue)
                    .zIndex(2)
            }
        }
    }
}
// MARK: - NowPlayingView Preview

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
            .environmentObject(SessionManager()) // If you use environment objects
    }
}
