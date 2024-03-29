import SwiftUI

struct SessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
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
                .environmentObject(sessionManager)
            
            Spacer()
            
            MiniPlayerBar(showingNowPlaying: $showNowPlaying)
        }
        .sheet(isPresented: $showNowPlaying) {
            NowPlayingView()
                .environmentObject(sessionManager)
        }
    }
}

struct TabContent: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Binding var selectedTab: Int
    
    var body: some View {
        switch selectedTab {
        case 0:
            DynamicSessionTimelineView()
        case 1:
            SessionQueueView(sessionManager: sessionManager)
        case 2:
            SongSearchView(sessionManager: sessionManager)
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
//struct SessionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionView()
//            .environmentObject(SessionManager())
//    }
//}
