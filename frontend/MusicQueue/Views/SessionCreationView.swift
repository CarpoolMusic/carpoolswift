//
//  SessionCreationView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct SessionCreationView: View {
    
    // MARK: - View Variables
        
        @State private var sessionName: String = ""
        @State private var isSessionPublic: Bool = true
        @Environment(\.presentationMode) var presentationMode
    
    // MARK: - View
        
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Session Name")) {
                        TextField("Enter session name", text: $sessionName)
                    }
                    
                    Section(header: Text("Session Type")) {
                        Toggle(isOn: $isSessionPublic) {
                            Text("Public Session")
                        }
                    }
                    
                    Section {
                        Button(action: createSession) {
                            Text("Create Session")
                        }
                        
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Create a Session")
        }
    }
    
    // MARK: - Methods
        
    func createSession() {
        // TODO: Insert logic to create a session here
        // For example, you could call a SessionManager singleton to create a new session with the input parameters, like:
        // SessionManager.shared.createSession(name: sessionName, isPublic: isSessionPublic)
        print("Session \(sessionName) Created!")
        self.presentationMode.wrappedValue.dismiss()
    }
}

//MARK: - Previews

struct SessionCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SessionCreationView()
    }
}
