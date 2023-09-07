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
        let sessionManager = dashboardViewModel.sessionManager
        if sessionManager.activeSession != nil {
            SessionView(sessionManager: sessionManager)
        } else {
            NavigationStack {
                VStack {
                    TitleView("Join a music session or create a new one.")
                    
                    TextFieldView("Enter a Session ID", )
                    TextField("Enter Session ID", text: $dashboardViewModel.sessionID)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    ButtonView(action: dashboardViewModel.handleJoinSessionButtonPressed(), buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())
                    
                    Spacer()
                    
                    ButtonView(action: dashboardViewModel.handleCreateSessionButtonPressed(), buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
                }
            }
        }
    }
    
    
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @State private var sessionID: String = ""
    @State private var showingAlert = false
    @State private var isCreateSessionButtonPressed = false
    @State private var isJoinSessionButtonPressed = false
    
    func handleJoinSessionButtonPressed () {
        if sessionID.isEmpty {
            showingAlert = true
        } else {
            sessionManager.joinSession(sessionID: sessionID)
        }
    }
    
    func handleCreateSessionButtonPressed () {
        self.isCreateSessionButtonPressed = true
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
