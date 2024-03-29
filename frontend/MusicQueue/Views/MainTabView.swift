import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var selection: Tab = .home

    enum Tab {
        case home
        case session
        case search
        case account
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            
            SessionListView(sessionManager: sessionManager)
                .tabItem {
                    Label("Session", systemImage: "music.note.list")
                }
                .tag(Tab.session)
        
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(Tab.account)
        }
    }
}

// The preview provider
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(SessionManager())
    }
}

