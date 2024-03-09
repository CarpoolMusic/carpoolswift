import SwiftUI
import MediaPlayer

struct PlayerControlView: View {
    @State var selectedButton: SelectedButton? = nil
    @Binding var showingQueue: Bool
    
    enum SelectedButton: String {
        case queue, airPlay, share
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: { toggleQueue() }) {
                    Image(systemName: "music.note.list")
                        .accessibilityLabel("Queue")
                }
                .buttonStyle(IconButtonStyle(isSelected: selectedButton == .queue))

                Spacer()

                Button(action: { toggleSelection(.airPlay) }) {
                    Image(systemName: "airplayaudio")
                        .accessibilityLabel("AirPlay")
                }
                .buttonStyle(IconButtonStyle(isSelected: selectedButton == .airPlay))

                Spacer()

                Button(action: { toggleSelection(.share) }) {
                    Image(systemName: "square.and.arrow.up")
                        .accessibilityLabel("Share")
                }
                .buttonStyle(IconButtonStyle(isSelected: selectedButton == .share))
            }
            .padding()
        }
        .padding()
    }
    
    // Functions remain unchanged
    func toggleQueue() {
        toggleSelection(.queue)
        showingQueue = !showingQueue
    }

    func openAirPlayMenu() {
        // Show AirPlay options
    }

    func shareSong() {
        // Implement sharing functionality
    }
    
    private func toggleSelection(_ button: SelectedButton) {
        if selectedButton == button {
            selectedButton = nil // Deselect if already selected
        } else {
            selectedButton = button // Select the button
        }
    }
}

struct PlayerControlView_Previews: PreviewProvider {
    static var previews: some View {
        @State var mockBool = false
        PlayerControlView(showingQueue: $mockBool)
    }
}
