//
//  SessionCreationView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct SessionCreationView: View {
    
    // MARK: - View Variables
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var sessionManager: SessionManager
    
    @State private var sessionName: String = ""
    @State private var isSessionPublic: Bool = true
    @State private var showingAlert: Bool = false
    @State private var isCreateSessionButtonPressed = false
    @State private var isJoinSessionButtonPressed = false
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField("Enter Session Name", text: $sessionName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    handleCreateSessionButtonPressed()
                }) {
                    Text("Create session")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Missing Session ID"), message: Text("Please enter a sessioID to join a session."), dismissButton: .default(Text("OK")))
                }
                .onReceive(sessionManager.$connected) { isConnected in
                    if self.isCreateSessionButtonPressed {
                        self.sessionManager.createSession()
                        self.isCreateSessionButtonPressed = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }
                
            }
            .navigationTitle("Create a Session")
        }
    }
    
    // MARK: - Methods
    
    func handleCreateSessionButtonPressed() {
        sessionManager.connect()
        self.isCreateSessionButtonPressed = true
    }
}

//MARK: - Previews

struct SessionCreationView_Previews: PreviewProvider {
    static var previews: some View {
        var mockSessionManager = SessionManager(socketService: SocketService(url: URL(string: "") ?? URL(fileURLWithPath: "")))
        SessionCreationView(sessionManager: mockSessionManager)
    }
}
