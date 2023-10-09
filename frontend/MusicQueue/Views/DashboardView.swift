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
        // create connection and connect
        self.socketConnectionHandler = SocketConnectionHandler()
        socketConnectionHandler.connect()
        
        // new session to either create or join
        self.sessionManager = SessionManager(socketConnectionHandler: socketConnectionHandler)
        
        
        self.attachConnectionSubscriber()
        
    }
    
    func handleJoinSessionButtonPressed() {
        self.sessionManager.joinSession(sessionId: sessionId)
    }
    
    func handleCreateSessionButtonPressed() {
        do {
            try self.sessionManager.createSession()
            
        } catch {
        }
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
