import SwiftUI

struct SessionJoinView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var sessionID = ""
    @ObservedObject var sessionManager: SessionManager

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Text("Join a Session")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                TextField("Session ID", text: $sessionID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: joinSession) {
                    Text("Join")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .disabled(sessionID.isEmpty)

                Spacer()
            }
            .padding()
            .navigationBarTitle("Join a Session", displayMode: .inline)
        }
    }

    func joinSession() {
        // Validate session ID
        // Join Session
        do {
            try self.sessionManager.joinSession(sessionId: sessionID, hostName: "current host name")
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Handle error
            print("Error joining session")
        }
    }
}

struct SessionJoinView_Previews: PreviewProvider {
    static var previews: some View {
        SessionJoinView(sessionManager: MockSessionManager())
    }
}

