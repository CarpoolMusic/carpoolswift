/**
The given Swift code is a simple SwiftUI view that displays either a DashboardView or an AuthorizationView based on the value of the isAuthenticated property in the ContentViewModel.

*/

import SwiftUI

// ContentView is a SwiftUI view that displays either DashboardView or AuthorizationView based on authentication status.
struct ContentView: View {
    @Injected private var logger: CustomLoggerProtocol
    
    @State private var isAuthenticated: Bool = false

    var body: some View {
        if isAuthenticated {
            MainTabView()
        } else {
            AuthorizationView(isAuthenticated: $isAuthenticated)
        }
    }
}

// ContentView_Previews provides a preview for ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
