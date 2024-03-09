import SwiftUI

struct SessionView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Picker("Categories", selection: $selectedTab) {
                Text("Timeline").tag(0)
                Text("Analytics").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
            
            // Content based on selected tab
            TabContent(selectedTab: $selectedTab)
            
            Spacer()
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
            SessionAnalyticsView()
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
    }
}
