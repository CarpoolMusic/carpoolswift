//
//  DashboardView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import SwiftUI
import Combine

struct DashboardView: View {
    
    @ObservedObject var dashboardViewModel = DashboardViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if (dashboardViewModel.isActive) {
//                    NowPlayingView(sessionManager: dashboardViewModel.sessionManager)
                    SessionView()
                    
                } else {
                    TitleView(title: "Carpool")
                    
                    Spacer()
                    
                    TextFieldView(displayText: "Enter a Session ID", inputText: $dashboardViewModel.sessionIdInput)

                    ButtonTextView(action: dashboardViewModel.handleJoinSessionButtonPressed, buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())
                        .disabled(!dashboardViewModel.connected)
                        .opacity(dashboardViewModel.connected ? 1.0 : 0.5)

                    
                    Spacer()
                    
                    ButtonTextView(action: dashboardViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
                        .disabled(!dashboardViewModel.connected)
                        .opacity(dashboardViewModel.connected ? 1.0 : 0.5)
                }
            }
            .sheet(isPresented: $dashboardViewModel.createSession) {
                SessionSettingsView(sessionManager: dashboardViewModel.sessionManager)
            }
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    static var shared = DashboardViewModel()
    
    @State var sessionIdInput: String = ""
    @Published var connected: Bool = false
    @Published var isActive = false
    @Published var createSession: Bool = false
    private var tempHostName: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
        
    var sessionManager: SessionManager
    
    init() {
        print("dashboard view model init called")
//         create connection and connect
//         new session to either create or join
        self.sessionManager = SessionManager()
        self.sessionManager.connect()
        sessionManager.$isConnected
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.connected = isConnected
                }
            }
            .store(in: &cancellables)
        print("IS ACTIVE ", self.isActive)
    }
    
    func connectSessionManager() {
        
    }
    
    func handleJoinSessionButtonPressed() {
        do {
            try self.sessionManager.joinSession(sessionId: sessionIdInput, hostName: tempHostName)
        } catch {
            // Handle error
        }
    }
    
    func handleCreateSessionButtonPressed() {
        self.createSession = true
        print("setting create session true")
        
        // listen for session activation
        sessionManager.$isActive
            .receive(on: RunLoop.main)
            .sink { [weak self] isActive in
                if isActive {
                    print("Session is now active")
                    // Close the createSessionView
                    self?.createSession = false
                    // Notify the view session is active
                    self?.isActive = isActive
                }
            }
            .store(in: &cancellables)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
