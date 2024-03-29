/**
 
 This code defines a SwiftUI view `SessionCreationView` that allows the user to create a new session. It uses an observed object `sessionCreationViewModel` to manage the state of the view and an observed object `sessionManager` to manage the sessions.
 
 The `SessionCreationViewModel` class is responsible for handling the logic of creating a new session. It has properties for showing an alert and storing the entered session name. The `handleCreateSessionButtonPressed()` method is called when the user presses the "Create Session" button, and it attempts to create a new session using the provided host name and session name.
 
 The `SessionCreationView_Previews` struct provides a preview of the `SessionCreationView` with a mock session manager for testing purposes.
 
 */
import SwiftUI
import Combine

// A view for creating a session
struct SessionSettingsView: View {
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var sessionCreationViewModel: SessionCreationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sessionName = ""
    @State private var sessionDescription = ""
    @State private var isPublic: Bool = true
    @State private var sessionPassword: String = ""
    
    @State private var hostControl: Bool = true
    @State private var enableVoting: Bool = false
    @State private var directSongAddition: Bool = true
    
    @State private var enableJoinLeaveNotifications: Bool = true
    @State private var enableSongChangeNotifications: Bool = true
    
    var genres = ["Pop", "Rock", "Jazz", "Electronic", "Classical", "Hip Hop", "Country"]
    @State private var selectedGenre: String = "Pop"
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionCreationViewModel = SessionCreationViewModel(sessionManager: sessionManager)
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Details")) {
                    TextField("Session Name", text: $sessionName)
                    TextField("Session Description", text: $sessionDescription)
                    Picker("Session Genre", selection: $selectedGenre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                }
                
                Section(header: Text("Privacy Settings")) {
                    Toggle("Public Session", isOn: $isPublic)
                    if !isPublic {
                        SecureField("Session Password", text: $sessionPassword)
                    }
                }
                
                Section(header: Text("Playback Control")) {
                    Toggle("Host Controls Playback", isOn: $hostControl)
                    Toggle("Enable Voting System", isOn: $enableVoting)
                    Toggle("Allow Direct Song Addition", isOn: $directSongAddition)
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Join/Leave Notifications", isOn: $enableJoinLeaveNotifications)
                    Toggle("Song Change Notifications", isOn: $enableSongChangeNotifications)
                }
                
                Button("Create Session") {
                    sessionCreationViewModel.handleCreateSessionButtonPressed(
                        sessionName: sessionName,
                        isPublic: isPublic,
                        sessionPassword: sessionPassword,
                        hostControl: hostControl,
                        enableVoting: enableVoting,
                        directSongAddition: directSongAddition,
                        enableJoinLeaveNotifications: enableJoinLeaveNotifications,
                        enableSongChangeNotifications: enableSongChangeNotifications,
                        selectedGenre: selectedGenre
                    )
                }
                .disabled(sessionName.isEmpty)
            }
            .navigationBarTitle("Create a Session", displayMode: .inline)
            .onChange(of: sessionCreationViewModel.sessionCreated) { sessionCreated in
                if sessionCreated {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

// A view model for session creation
class SessionCreationViewModel: ObservableObject {
    
    @Published var sessionCreated: Bool = false
    
    private var cancellables = Set<AnyCancellable>() // Cancellables for handling Combine subscriptions
    
    let sessionManager: SessionManager // The session manager
    
    // Initialize the view model with a session manager
    init(sessionManager: SessionManager) {
        print("session manager init called")
        self.sessionManager = sessionManager
    }
    
    // Handle the create session button pressed event
    func handleCreateSessionButtonPressed(sessionName: String, isPublic: Bool, sessionPassword: String, hostControl: Bool, enableVoting: Bool, directSongAddition: Bool, enableJoinLeaveNotifications: Bool, enableSongChangeNotifications: Bool, selectedGenre: String) {
        do {
            try self.sessionManager.createSession(hostName: "this host name", sessionName: sessionName) // Create a new session with the given host name and session name
            self.sessionCreated = true
        } catch {
            print("Error creating session")
        }
    }
}

// A preview provider for the SessionCreationView
struct SessionSettingsView_Previews : PreviewProvider {
    static var previews : some View {
        let mockSessionManager = SessionManager()
        return SessionSettingsView(sessionManager: mockSessionManager)
    }
}
