//
//  DashboardView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var musicService: AnyMusicService
    @State private var sessionID: String = ""

    var body: some View {
        VStack {
            Spacer()

            Text("MusicQueue")
                .font(.largeTitle)
                .fontWeight(.heavy)

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
                joinSession()
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

            Spacer()

            Button(action: {
                // Action to create session
                createSession()
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

    private func joinSession() {
        // Implement functionality to join a session
    }

    private func createSession() {
        // Implement functionality to create a new session
    }
}

struct DashboardView_Previews: PreviewProvider {
    // Just choose a mock music service
    static var mockMusicService = AppleMusicService()

    static var previews: some View {
        DashboardView(musicService: AnyMusicService(mockMusicService))
    }
}
