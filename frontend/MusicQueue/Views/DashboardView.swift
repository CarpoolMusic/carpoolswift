//
//  DashboardView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var musicService: AnyMusicService
    @ObservedObject var sessionManager: SessionManager
    
    @State private var sessionID: String = ""
    @State private var showingAlert = false
    @State private var isCreateSessionButtonPressed = false
    @State private var isJoinSessionButtonPressed = false
    
    var body: some View {
        if sessionManager.activeSession != nil {
            SessionView(sessionManager: sessionManager)
        } else {
            NavigationStack {
                VStack {
                    Text("Join a music session or create a new one.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    TextField("Enter Session ID", text: $sessionID)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // Action to join session
                        handleJoinSessionButtonPressed()
                    }) {
                        Text("Join Session")
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
                        if self.isJoinSessionButtonPressed {
                            self.sessionManager.joinSession(sessionID: sessionID)
                            self.isJoinSessionButtonPressed = false
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to create session
                        handleCreateSessionButtonPressed()
                    }) {
                        Text("Create Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .onAppear(perform: loadUser)
                .navigationDestination(isPresented: $isCreateSessionButtonPressed) {
                    SessionCreationView(sessionManager: sessionManager)
                }
                .navigationTitle("Dashboard")
            }
        }
        
    }
    
    private func loadUser() {
        Task {
            do {
                let user = try await musicService.fetchUser()
                // handle user
            } catch {
                // handle error
            }
        }
    }
    
    private func handleJoinSessionButtonPressed () {
        if sessionID.isEmpty {
            showingAlert = true
        } else {
            sessionManager.joinSession(sessionID: sessionID)
        }
    }
    
    private func handleCreateSessionButtonPressed () {
        self.isCreateSessionButtonPressed = true
    }
}

struct DashboardView_Previews: PreviewProvider {
    // Just choose a mock music service
    static var mockMusicService = AppleMusicService()
    static var mockSessionManager = SessionManager(socketService: SocketService(url: URL(string: "") ?? URL(fileURLWithPath: "")))
    
    static var previews: some View {
        DashboardView(musicService: AnyMusicService(mockMusicService), sessionManager: mockSessionManager)
    }
}
