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
                
                TextFieldView(displayText: "Enter a Session ID", inputText: $dashboardViewModel.sessionId)
                TextField("Enter Session ID", text: $dashboardViewModel.sessionId)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                

                ButtonView(action: dashboardViewModel.handleJoinSessionButtonPressed, buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())
                    .disabled(!dashboardViewModel.connected)
                    .opacity(dashboardViewModel.connected ? 1.0 : 0.5)

                
                Spacer()
                
                ButtonView(action: dashboardViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
                
            }
        }
        .navigationDestination(
        isPresented: $dashboardViewModel.sessionIsActive) {
            SessionView()
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @Published var sessionId: String = ""
    @Published var connected = false
    @Published var sessionIsActive = false
        
    var socketConnectionHandler: SocketConnectionHandler
    var socketEventSender: SocketEventSender
    var sessionManager: SessionManager
    
    init() {
        guard let url = URL(string: "http://localhost:8080")
        else { return }
        
        // create connection and connect
        socketConnectionHandler = SocketConnectionHandler(url: url)
        socketConnectionHandler.connect()
        
        // new session to either create or join
        self.sessionManager = SessionManager(socketConnectionHandler: socketConnectionHandler)
        
        // subscribe session to socket events
        let subscription = socketConnectionHandler.eventPublisher
            .sink { event, items in
                self.handleSubscriptionEvents(event: event, items: items)
            }
        
    }
    
    func handleJoinSessionButtonPressed() {
        self.sessionManager.joinSession(sessionId: sessionId)
    }
    
    func handleCreateSessionButtonPressed() {
        self.sessionManager.createSession()
    }
    
    // MARK: - Subsctiption Events
    func handleSubscriptionEvents(event: String, items: [Any]) {
        switch event {
        case "connected":
            self.connected = true
        case "sessionJoined":
            self.sessionIsActive = true
        default:
            print("Unhandled event")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
