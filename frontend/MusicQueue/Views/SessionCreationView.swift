/**
 
This code defines a SwiftUI view `SessionCreationView` that allows the user to create a new session. It uses an observed object `sessionCreationViewModel` to manage the state of the view and an observed object `sessionManager` to manage the sessions.

The `SessionCreationViewModel` class is responsible for handling the logic of creating a new session. It has properties for showing an alert and storing the entered session name. The `handleCreateSessionButtonPressed()` method is called when the user presses the "Create Session" button, and it attempts to create a new session using the provided host name and session name.

The `SessionCreationView_Previews` struct provides a preview of the `SessionCreationView` with a mock session manager for testing purposes.
 
 */
import SwiftUI
import Combine

// A view for creating a session
struct SessionCreationView: View {
    @ObservedObject var sessionManager: SessionManager // The observed object for managing sessions
    @ObservedObject var sessionCreationViewModel: SessionCreationViewModel // The observed object for managing session creation

    // Initialize the view with a session manager
    init(sessionManager: SessionManager) {
        print("init session creation view")
        self.sessionManager = sessionManager
        self.sessionCreationViewModel = SessionCreationViewModel(sessionManager: sessionManager)
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextFieldView(displayText: "Enter Session Name", inputText: $sessionCreationViewModel.sessionName) // A text field for entering the session name
                Spacer()
                ButtonTextView(action: sessionCreationViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle()) // A button for creating a new session
                    .disabled(!sessionCreationViewModel.sessionManager.isConnected) // Disable the button if not connected to a server
                    .opacity(sessionCreationViewModel.sessionManager.isConnected ? 1 : 0.5) // Reduce opacity if not connected to a server
                    .alert(isPresented: $sessionCreationViewModel.isShowingAlert) { // Show an alert if showing alert flag is true
                        Alert(title: Text("Missing Session ID"), message: Text("Please enter a sessioID to join a session."), dismissButton: .default(Text("OK")))
                    }
            }
            .navigationTitle("Create a Session") // Set navigation title
        }
    }
}

// A view model for session creation
class SessionCreationViewModel: ObservableObject {
    @Published var isShowingAlert = false // Flag for showing alert
    @Published var sessionName = "" // The session name

    private var cancellables = Set<AnyCancellable>() // Cancellables for handling Combine subscriptions

    let sessionManager: SessionManager // The session manager

    // Initialize the view model with a session manager
    init(sessionManager: SessionManager) {
        print("session manager init called")
        self.sessionManager = sessionManager
    }

    // Handle the create session button pressed event
    func handleCreateSessionButtonPressed() {
        do {
            try self.sessionManager.createSession(hostName: "this host name", sessionName: sessionName) // Create a new session with the given host name and session name
        } catch {
            print("Error creating session")
        }
    }
}

// A preview provider for the SessionCreationView
struct SessionCreationView_Previews : PreviewProvider {
    static var previews : some View {
        let mockSessionManager = SessionManager()
        return SessionCreationView(sessionManager: mockSessionManager)
    }
}
