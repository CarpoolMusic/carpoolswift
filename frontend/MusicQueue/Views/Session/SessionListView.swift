import SwiftUI

struct SessionSample: Identifiable {
    let id = UUID()
    let name: String
    let albumArt: String // URL or name of the image asset
}

// Assuming "AlbumArt1" and "AlbumArt2" are placeholders for actual image assets you have.
let sampleSessions = [
    SessionSample(name: "Session 1", albumArt: "AlbumArt1"),
    SessionSample(name: "Session 2", albumArt: "AlbumArt2")
]


struct SessionListView: View {
    @ObservedObject var sessionManager: SessionManager
    @State var sessions: [SessionSample] = sampleSessions
    @State var showingSessionCreationView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if sessions.isEmpty {
                    Text("You are not currently in any sessions.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(sessions) { session in
                            ZStack {
                                Image(systemName: "music.note") // Placeholder for actual image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width - 20, height: 100)
                                    .cornerRadius(10)
                                    .blur(radius: 5)
                                    .clipped()
                                
                                Text(session.name)
                                    .foregroundColor(.black)
                                    .bold()
                            }
                            .frame(height: 100)
                            .listRowInsets(EdgeInsets())
                            .background(Color.clear)
                            .padding(.vertical, 8) // Add vertical padding
                            // To make the padding part of the tap area, you can use a background here.
                            .background(Color.white) // Or any other color that fits your design
                            .cornerRadius(10) // Apply cornerRadius to the background
                            .shadow(radius: 2) // Optional: add a shadow for better separation
                        }
                    }
                    .listStyle(PlainListStyle()) // Use PlainListStyle to remove list lines
                    .navigationTitle("My Sessions")
                }
                
                Button(action: {
                    self.showingSessionCreationView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .padding()
                }
                .sheet(isPresented: $showingSessionCreationView) {
                    SessionSettingsView(sessionManager: sessionManager)
                }
            }
        }
    }
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(sessionManager: MockSessionManager())
    }
}
