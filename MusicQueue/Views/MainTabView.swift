import SwiftUI
import Combine

struct MainTabView: View {
    @Injected private var sessionManager: any SessionManagerProtocol
    
    @State private var isActiveSession: Bool = false
    @State private var selection: Tab = .home
    
    private var cancellables = Set<AnyCancellable>()
    
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
            
            if isActiveSession, let session = sessionManager.activeSession {
                SessionView()
                .environmentObject(session)
                .tabItem {
                    Label("Session", systemImage: "music.note.list")
                }
                .tag(Tab.session)
            } else {
                SessionMenu()
                .tabItem {
                    Label("Session", systemImage: "music.note.list")
                }
                .tag(Tab.session)
            }
    
        AccountView()
            .tabItem {
                Label("Account", systemImage: "person.crop.circle")
            }
            .tag(Tab.account)
        }
        .onReceive(sessionManager.sessionConnectivityPublisher.receive(on: RunLoop.main)) { isActive in
            DispatchQueue.main.async {
                self.isActiveSession = isActive
            }
        }
    }
}

// The preview provider
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

