//
//  DashboardView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import SwiftUI
import Combine

struct DashboardView: View {
    
    @ObservedObject var dashboardViewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .navigationDestination(
                isPresented: $dashboardViewModel.isActive) {
                    SessionView(sessionManager: dashboardViewModel.sessionManager)
            }
            .sheet(isPresented: $dashboardViewModel.createSession) {
                SessionCreationView(sessionManager: dashboardViewModel.sessionManager)
            }
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @State var sessionIdInput: String = ""
    @Published var connected: Bool = false
    @Published var isActive = false
    @Published var createSession: Bool = false
    private var tempHostName: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
        
    var sessionManager: SessionManager
    
    init() {
        // create connection and connect
        // new session to either create or join
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
        
        // listen for session activation
        sessionManager.$isActive
            .receive(on: RunLoop.main)
            .sink { [weak self] isActive in
                if isActive {
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
