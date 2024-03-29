/**
The given Swift code is a simple SwiftUI view that displays either a DashboardView or an AuthorizationView based on the value of the isAuthenticated property in the ContentViewModel.

*/

import SwiftUI

// ContentView is a SwiftUI view that displays either DashboardView or AuthorizationView based on authentication status.
struct ContentView: View {
    // contentViewModel is an observed object that manages authentication state.
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        if contentViewModel.isAuthenticated {
            MainTabView()
                .environmentObject(SessionManager())
        } else {
            AuthorizationView()
        }
    }
}

// ContentViewModel is an observable object that manages authentication state.
class ContentViewModel: ObservableObject {
    // isAuthenticated represents the authentication status.
    @Published var isAuthenticated = false
}

// ContentView_Previews provides a preview for ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
