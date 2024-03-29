import SwiftUI

struct AnimatedBackgroundView: View {
    // Define the number of bubbles and their properties
    private let bubbleCount = 30
    private let minSize: CGFloat = 10
    private let maxSize: CGFloat = 30
    
    // Create an array to hold the animations
    private let animations: [Animation] = (0..<30).map { _ in
        Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5)
            .repeatForever()
            .delay(Double.random(in: 0...2))
            .speed(Double.random(in: 0.2...1))
    }
    
    // A view that creates a bubble
    private func bubble(at index: Int) -> some View {
        Circle()
            .fill(Color.white.opacity(0.3))
            .frame(width: CGFloat.random(in: minSize...maxSize),
                   height: CGFloat.random(in: minSize...maxSize))
            .scaleEffect(0.5)
            .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                      y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
            .animation(animations[index], value: animations[index])
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<bubbleCount, id: \.self) { index in
                bubble(at: index)
                    .onAppear {
                        let animation = animations[index]
                        withAnimation(animation) {
                            // This just toggles the scale effect on and off
                            // You could adjust the position or opacity over time as well
                        }
                    }
            }
        }
    }
}

struct HomeView: View {
    @State private var appear = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Carpool")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .scaleEffect(appear ? 1 : 0.5)
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 1.2), value: appear)
                
                // Placeholder for the logo
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .scaleEffect(appear ? 1 : 0.1)
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 1.5), value: appear)
            }
            .onAppear {
                appear = true
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AnimatedBackgroundView()) // Use the animated background
        .ignoresSafeArea()
    }
}

struct WelcomeBackView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
