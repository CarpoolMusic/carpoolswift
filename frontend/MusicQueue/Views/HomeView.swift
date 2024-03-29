import SwiftUI

struct AnimatedBackgroundView: View {
    private let bubbleCount = 30
    private let minSize: CGFloat = 10
    private let maxSize: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<bubbleCount, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: CGFloat.random(in: minSize...maxSize),
                               height: CGFloat.random(in: minSize...maxSize))
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: CGFloat.random(in: 0...geometry.size.height))
                        .animation(
                            Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5)
                                .repeatForever()
                                .delay(Double.random(in: 0...2))
                                .speed(Double.random(in: 0.2...1)),
                            value: UUID()
                        )
                }
            }
            .drawingGroup() // Optimizes performance by rasterizing the content
        }
    }
}

struct HomeView: View {
    @State private var appear = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Text("Welcome to MusicQueue")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(appear ? 1 : 0.5)
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 1.2), value: appear)
                
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
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
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .overlay(AnimatedBackgroundView()) // Subtle animated overlay
        .ignoresSafeArea()
    }
}

struct WelcomeBackView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

