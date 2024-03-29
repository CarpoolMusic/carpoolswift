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
                PlayerControlButton(
                    iconName: "music.note.list",
                    isSelected: selectedButton == .queue,
                    action: { toggleQueue() }
                )

                Spacer()

                PlayerControlButton(
                    iconName: "airplayaudio",
                    isSelected: selectedButton == .airPlay,
                    action: { toggleSelection(.airPlay) }
                )

                Spacer()

                PlayerControlButton(
                    iconName: "square.and.arrow.up",
                    isSelected: selectedButton == .share,
                    action: { toggleSelection(.share) }
                )
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
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

struct PlayerControlButton: View {
    let iconName: String
    var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .foregroundColor(isSelected ? Color.blue : Color.white)
                .frame(width: 44, height: 44)
                .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
                .cornerRadius(22)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut, value: isSelected)
    }
}

struct PlayerControlView_Previews: PreviewProvider {
    static var previews: some View {
        StateWrapper()
    }

    struct StateWrapper: View {
        @State var showingQueue = false

        var body: some View {
            PlayerControlView(showingQueue: $showingQueue)
        }
    }
}

