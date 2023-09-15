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
                        isPresented: $dashboardViewModel.inSession) {
                            SessionView()
                        }

                ButtonView(action: dashboardViewModel.handleJoinSessionButtonPressed, buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())
                    .disabled(!dashboardViewModel.connected)
                    .opacity(dashboardViewModel.connected ? 1.0 : 0.5)

                
                Spacer()
                
                ButtonView(action: dashboardViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
            }
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @Published private var sessionID: String
        
    var socketConnection: SocketConnectionHandler
    var socketEventSender: SocketEventSender
    var sessionManager: SessionManager
    
    init() {
        guard let url = URL(string: "http://localhost:8080")
        else { return }
        
        socketConnection = SocketConnectionHandler(url: url)
        
        // Connect to the server
        socketEventSender = SocketEventSender(connection: socketConnection)
        socketEventSender.connect()
        
        // new session to either create or join
        self.sessionManager = SessionManager()
    }
    
    func handleJoinSessionButtonPressed() {
        self.socketEventSender.joinSession(sessionID: sessionID)
    }
    
    func handleCreateSessionButtonPressed() {
        
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
