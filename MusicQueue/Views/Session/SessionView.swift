import SwiftUI

struct SessionView: View {
    @EnvironmentObject private var activeSession: Session
    
    @ObservedObject private var mediaPlayer = MediaPlayer()
    
    @State private var selectedTab = 1
    @State private var showNowPlaying = false
    
    var body: some View {
        VStack {
            Picker("Categories", selection: $selectedTab) {
                Text("Timeline").tag(0)
                Text("Queue").tag(1)
                Text("Search").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
            
            // Content based on selected tab
            TabContent(selectedTab: $selectedTab)
            
            Spacer()
            
            if !activeSession.queue.isEmpty {
                MiniPlayerBar(showingNowPlaying: $showNowPlaying)
                    .environmentObject(mediaPlayer)
                    .environmentObject(activeSession)
            }
        }
        .sheet(isPresented: $showNowPlaying) {
            NowPlayingView()
                .environmentObject(mediaPlayer)
        }
    }
}

struct TabContent: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        switch selectedTab {
        case 0:
            DynamicSessionTimelineView()
        case 1:
            SessionQueueView()
        case 2:
            SongSearchView()
        default:
            Text("Selection does not exist")
        }
    }
}

// Placeholder views for each category
struct DynamicSessionTimelineView: View {
    var body: some View {
        // Placeholder for Dynamic Session Timeline content
        Text("Dynamic Session Timeline")
    }
}

struct SessionAnalyticsView: View {
    var body: some View {
        // Placeholder for Session Analytics content
        Text("Session Analytics")

    }
}

// Preview
struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
            .environmentObject(SessionManager())
    }
}
