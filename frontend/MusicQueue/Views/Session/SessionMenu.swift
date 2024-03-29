import SwiftUI

struct SessionMenu: View {
    @State private var showingSessionCreationView = false
    @State private var showingSessionJoinView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Text("Welcome to Sessions")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Create or join a session to get started.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                Button(action: {
                    showingSessionCreationView = true
                }) {
                    Text("Create Session")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showingSessionCreationView) {
                    SessionCreationView()
                }

                Button(action: {
                    showingSessionJoinView = true
                }) {
                    Text("Join Session")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showingSessionJoinView) {
                    SessionJoinView()
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct SimpleSessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionMenu()
    }
}

