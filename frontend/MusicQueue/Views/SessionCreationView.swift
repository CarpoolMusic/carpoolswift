//
//  SessionCreationView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI
import Combine

struct SessionCreationView: View {
    
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var sessionCreationViewModel: SessionCreationViewModel
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionCreationViewModel = SessionCreationViewModel(sessionManager: sessionManager)
    }
    
    // MARK: - View
    
    var body: some View {
        VStack{}
        NavigationView {
            VStack {
                Spacer()
                TextFieldView(displayText: "Enter Session Name", inputText: $sessionCreationViewModel.sessionName)

                Spacer()

                ButtonTextView(action: sessionCreationViewModel.handleCreateSessionButtonPressed, buttonText: Text("Create Session"), buttonStyle: ButtonBackgroundStyle())
                    .disabled(!sessionCreationViewModel.sessionManager.isConnected)
                    .opacity(sessionCreationViewModel.sessionManager.isConnected ? 1 : 0.5)
                    .alert(isPresented: $sessionCreationViewModel.isShowingAlert) {
                        Alert(title: Text("Missing Session ID"), message: Text("Please enter a sessioID to join a session."), dismissButton: .default(Text("OK")))
                    }
            }
            .navigationTitle("Create a Session")
        }
    }
    
    
}
class SessionCreationViewModel: ObservableObject {
    @State var isShowingAlert = false
    @State var sessionName: String = ""
    
    @State private var isSessionPublic: Bool = true
    @State private var showingAlert: Bool = false
    @State private var isJoinSessionButtonPressed = false
    
    var sessionManager: SessionManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.sessionManager.connect()
    }

    // MARK: - Methods

    func handleCreateSessionButtonPressed() {
        do {
            try self.sessionManager.createSession(hostName: "this host name", sessionName: sessionName)
        } catch {
            print("Error creating session")
        }
        
    }
}

//MARK: - Previews

struct SessionCreationView_Previews: PreviewProvider {
    static var previews: some View {
//        var mockSessionManager = SessionManager(socketService: SocketService(url: URL(string: "") ?? URL(fileURLWithPath: "")))
//        SessionCreationView(sessionManager: mockSessionManager)
        VStack{}
    }
}
