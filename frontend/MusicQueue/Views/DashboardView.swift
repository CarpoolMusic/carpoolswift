//
//  DashboardView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var dashboardViewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TitleView(title: "Join a music session or create a new one.")
                
                TextFieldView(displayText: "Enter a Session ID", inputText: dashboardViewModel.$sessionID)
                TextField("Enter Session ID", text: $dashboardViewModel.sessionID)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                    .navigationDestination(
                        isPresented: $dashboardViewModel.sessionJoined) {
                            SessionView()
                        }

                ButtonView(action: dashboardViewModel.handleJoinSessionButtonPressed, buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())

                
                Spacer()
                
                ButtonView(action: dashboardViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
            }
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @State var sessionID: String = ""
    @State private var showingAlert = false
    
    // Determines whether or not the appRemote is connected
    // gray out buttons if not connected and make them active otherwise
    // We can use the same method with socketConnection
    @State var appRemoteConnectionStatus: ConnectionStatus = .undetermined
    @State var socketConnectionStatus: ConnectionStatus = .undetermined
    
    @Published var socketConnection: SocketConnectionHandler?
    
    
    // notifies the view when to move to sessionView
    @Published var sessionJoined: Bool = false
    
    func handleJoinSessionButtonPressed() {
        guard !sessionID.isEmpty else {
            showingAlert = true
            return
        }
        if let socketUrl = URL(string: "http://localhost:8080") {
            // Note: we need to handle some sort of sync here to lock-step
            socketConnection = SocketConnectionHandler(url: socketUrl)
            socketConnection!.connect()
            
            let socketEventSender = SocketEventSender(connection: socketConnection!)
            socketEventSender.joinSession(sessionID: sessionID)
            self.sessionJoined = true
        }
    }
    
    func handleCreateSessionButtonPressed () {
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    // Just choose a mock music service
    static var mockMusicService = AppleMusicService()
    static var mockSessionManager = SessionManager(socketService: SocketService(url: URL(string: "") ?? URL(fileURLWithPath: "")))
    
    static var previews: some View {
        DashboardView()
    }
}
