import SwiftUI
/**
 This struct represents the view for the menu bar.
 
 - Parameters:
    - sessionManager: An observed object that manages the session.
    - sessionViewModel: An observed object that represents the session view model.
 */
struct MenuBarView: View {
    
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var sessionViewModel: SessionViewModel
    
    /**
     The body of the view.
     */
    var body: some View {
        HStack {
            Button(action: handleQueueButtonPressed) {
                Image(systemName: "line.horizontal.3")
                    .font(.largeTitle)
            }
            .padding()
            
            Spacer()
            
            Button(action: { /* Handle chat button action */ }) {
                Image(systemName: "bubble.right")
                    .font(.largeTitle)
            }
            .padding()
            
            Button(action: handleLeaveSessionButtonSelected) {
                Image(systemName: "arrow.turn.up.left")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            .padding()
        }
    }
    
    /**
     Handles the action when the leave session button is selected.
     */
    private func handleLeaveSessionButtonSelected() {
        do {
            try sessionManager.leaveSession()
        } catch {
            print("error leaving session")
        }
    }
    
    /**
     Handles the action when the queue button is pressed.
     */
    private func handleQueueButtonPressed() {
        sessionViewModel.isQueueOpen = true
    }
}
