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
                
                TextFieldView(displayText: "Enter a Session ID", inputText: $dashboardViewModel.sessionId)

                ButtonTextView(action: dashboardViewModel.handleJoinSessionButtonPressed, buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())
                    .disabled(!dashboardViewModel.connected)
                    .opacity(dashboardViewModel.connected ? 1.0 : 0.5)

                
                Spacer()
                
                ButtonTextView(action: dashboardViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
                
            }
        }
        .navigationDestination(
            isPresented: $dashboardViewModel.sessionManager.isConnected) {
                SessionView(sessionManager: dashboardViewModel.sessionManager)
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @Published var sessionId: String = ""
    @Published var connected: Bool = false
    
    private var cancellable: AnyCancellable? = nil
        
    var sessionManager: SessionManager
    
    init() {
        // create connection and connect
        // new session to either create or join
        self.sessionManager = SessionManager()
    }
    
    func handleJoinSessionButtonPressed() {
        do {
            try self.sessionManager.joinSession(sessionId: sessionId)
        } catch {
            // Handle error
        }
    }
    
    func handleCreateSessionButtonPressed() {
        do {
            try self.sessionManager.createSession(hostName: "", sessionName: "")
            
        } catch {
            // Handle error
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
