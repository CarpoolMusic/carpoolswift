//
//  ContentView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - State
        
    @State private var sessionCode: String = ""
    @State private var userName: String = "User" // Replace with actual authenticated user's name
    
    // MARK: - View
    
    var body: some View {
        rootView
//        .welcomeSheet()
    }
    
    /// The top-level content view.
    private var rootView: some View {
        NavigationView {
            VStack {
                userInfoView
                joinSessionView
                createSessionView
            }
            .navigationBarTitle("MusicQueue")
        }
    }
        
    /// View for displaying user's name and profile icon.
    private var userInfoView: some View {
        HStack {
            Text("Welcome, \(userName)!")
                .font(.title)
            Spacer()
            Button(action: viewProfile) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }
        .padding()
    }
    
    /// View for joining an existing session.
    private var joinSessionView: some View {
        VStack {
            TextField("Session Code", text: $sessionCode)
            Button(action: joinSession) {
                Text("Join Existing Session")
            }
        }
        .padding()
    }
    
    /// View for creating a new session.
    private var createSessionView: some View {
        VStack {
            Button(action: createSession) {
                Text("Create New Session")
            }
        }
        .padding()
    }
    
    // MARK: - Methods
        
    private func handleSessionCodeChange(_ newSessionCode: String) {
        // Logic to handle change in session code.
    }
    
    private func createSession() {
        // Logic to create a new session.
    }
    
    private func joinSession() {
        // Logic to join an existing session.
    }
    
    private func viewProfile() {
        // Logic to view user profile.
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
