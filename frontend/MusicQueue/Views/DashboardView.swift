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
                TitleView(title: "Join a music session or create a new one.")
                
                TextFieldView(displayText: "Enter a Session ID", inputText: $dashboardViewModel.sessionId)
                TextField("Enter Session ID", text: $dashboardViewModel.sessionId)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                

                ButtonTextView(action: dashboardViewModel.handleJoinSessionButtonPressed, buttonText: Text("Join Session"), buttonStyle: ButtonBackgroundStyle())
                    .disabled(!dashboardViewModel.connected)
                    .opacity(dashboardViewModel.connected ? 1.0 : 0.5)

                
                Spacer()
                
                ButtonTextView(action: dashboardViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
                
            }
        }
        .navigationDestination(
            isPresented: $dashboardViewModel.sessionManager.isActive) {
                SessionView(sessionManager: dashboardViewModel.sessionManager)
        }
    }
}

// MARK: - View Model

class DashboardViewModel: ObservableObject {
    
    @Published var sessionId: String = ""
    @Published var connected: Bool = false
    
    private var cancellable: AnyCancellable? = nil
        
    var socketConnectionHandler: SocketConnectionHandler
    var sessionManager: SessionManager
    
    init() {
        let url = URL(string: "http://localhost:8080")
        
        // create connection and connect
        self.socketConnectionHandler = SocketConnectionHandler(url: url!)
        socketConnectionHandler.connect()
        
        // new session to either create or join
        self.sessionManager = SessionManager(socketConnectionHandler: socketConnectionHandler)
        
        
        self.attachConnectionSubscriber()
        
    }
    
    func handleJoinSessionButtonPressed() {
        self.sessionManager.joinSession(sessionId: sessionId)
    }
    
    func handleCreateSessionButtonPressed() {
        self.sessionManager.createSession()
    }
    
    func attachConnectionSubscriber() {
        cancellable = socketConnectionHandler.$connected
            .sink { status in
                self.connected = status
            }
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
