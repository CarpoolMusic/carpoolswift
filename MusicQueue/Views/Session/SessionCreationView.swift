/**
 
 This code defines a SwiftUI view `SessionCreationView` that allows the user to create a new session. It uses an observed object `sessionCreationViewModel` to manage the state of the view and an observed object `sessionManager` to manage the sessions.
 
 The `SessionCreationViewModel` class is responsible for handling the logic of creating a new session. It has properties for showing an alert and storing the entered session name. The `handleCreateSessionButtonPressed()` method is called when the user presses the "Create Session" button, and it attempts to create a new session using the provided host name and session name.
 
 The `SessionCreationView_Previews` struct provides a preview of the `SessionCreationView` with a mock session manager for testing purposes.
 
 */
import SwiftUI
import Combine

// A view for creating a session
struct SessionCreationView: View {
    @ObservedObject var sessionCreationViewModel: SessionCreationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // temp
    @State private var hostName = "temp"

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

    init() {
        self.sessionCreationViewModel = SessionCreationViewModel()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create New Session")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

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
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, -10) // Adjust based on your Form's visual needs

                Button(action: {
                    sessionCreationViewModel.handleCreateSessionButtonPressed(
                        sessionName: sessionName,
                        hostName: hostName)
                }) {
                    Text("Create Session")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .opacity(sessionName.isEmpty ? 0.5 : 1)
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .disabled(sessionName.isEmpty)

                Spacer()
            }
            .padding()
            .onChange(of: sessionCreationViewModel.activeSession) { sessionCreated in
                if sessionCreated {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

// A view model for session creation
class SessionCreationViewModel: ObservableObject {
    @Injected private var notificationCenter: NotificationCenterProtocol
    
    @Published var activeSession = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var sessionManager: SessionManager? // The session manager
    
    private var sessionName: String = ""
    private var hostName: String = ""
    
    // Initialize the view model with a session manager
    init() {}
    
    
    // Handle the create session button pressed event
    func handleCreateSessionButtonPressed(sessionName: String, hostName: String) {
        self.sessionName = sessionName
        self.hostName = hostName
        do {
            DependencyContainer.shared.registerSessionManager(sessionId: "", sessionName: sessionName, hostName: hostName)
            try self.sessionManager?.createSession(hostId: hostName, sessionName: sessionName)
        } catch {
            print("Error creating session")
        }
    }
}


// A preview provider for the SessionCreationView
struct SessionSettingsView_Previews : PreviewProvider {
    static var previews : some View {
        return SessionCreationView()
    }
}
