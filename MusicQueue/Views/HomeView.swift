import SwiftUI

struct HomeView: View {
    @State private var services: [String] = []

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Top section with system name and icons
                    HStack {
                        Text("Your System")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(spacing: 20) {
                            Image(systemName: "person.crop.circle")
                            Image(systemName: "gearshape")
                        }
                    }
                    .padding()

                    // Recently Played section
                    VStack(alignment: .leading) {
                        Text("Recently Played")
                            .font(.title2)
                            .padding(.bottom, 5)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 80)
                            .overlay(
                                Text("Your recent history will show here once you’ve played some content.")
                                    .foregroundColor(.gray)
                                    .padding()
                            )
                    }
                    .padding()

                    // Services section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Your Services")
                                .font(.title2)
                            Spacer()
                        }
                        .padding(.bottom, 5)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(services, id: \.self) { service in
                                    ServiceIcon(imageName: service)
                                }
                                AddServiceIcon {
                                    // Stub for adding a new service
                                    // Replace this with actual logic to add a service
                                    services.append("service-\(services.count + 1)")
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()

                    // Playlists section
                    VStack(alignment: .leading) {
                        Text("Your Playlists")
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.bottom, 5)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<5) { index in
                                    PlaylistItem()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            }

            // Player at the bottom
            VStack {
                Spacer()
                PlayerView()
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
    }
}

struct ServiceIcon: View {
    var imageName: String

    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
    }
}

struct AddServiceIcon: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
        }
    }
}

struct PlaylistItem: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "music.note")
                .resizable()
                .frame(width: 150, height: 150)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Text("Playlist Name")
                .font(.headline)
            Text("Description")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
    }
}

struct PlayerView: View {
    @State private var showFullPlayer = false
    @State private var offsetY: CGFloat = 0.0

    var body: some View {
        VStack {
            Spacer()
            
            if showFullPlayer {
                FullPlayerView()
                    .transition(.move(edge: .bottom))
                    .gesture(
                        DragGesture().onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation {
                                    showFullPlayer = false
                                }
                            }
                        }
                    )
            } else {
                MiniPlayerView()
                    .onTapGesture {
                        withAnimation {
                            showFullPlayer.toggle()
                        }
                    }
            }
        }
        .animation(.interactiveSpring(), value: offsetY)
    }
}


struct MiniPlayerView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    VStack {
                        HStack {
                            // Album Art
                            Image(systemName: "music.note")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                                .padding(.leading, 10)

                            // Song Info
                            VStack(alignment: .leading) {
                                Text("Bedroom")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Text("Kaleidoscope Colours")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                HStack {
                                    Image(systemName: "spotify")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.white)
                                    Text("Deep House Blend")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Jan Blomqvist")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)

                            Spacer()

                            // Play/Pause Button
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                        }
                        .padding(.top, 5)

                        // Volume Slider
                        HStack {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            Slider(value: .constant(0.5))
                                .accentColor(.white)
                            Text("18")
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                        }
                        .padding(.bottom, 5)
                    }
                )
                .padding(.horizontal)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct FullPlayerView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    VStack {
                        // Album Art
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                            .padding(.top, 20)
                        
                        Spacer()

                        // Song Info
                        VStack(alignment: .leading) {
                            Text("Kaleidoscope Colours")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Jan Blomqvist • Deep House Blend")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            HStack {
                                Image(systemName: "spotify")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Text("Spotify")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)

                        // Playback Controls
                        HStack {
                            Image(systemName: "shuffle")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "backward.fill")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "forward.fill")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "repeat")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 40)

                        // Volume Slider
                        HStack {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.white)
                            Slider(value: .constant(0.5))
                                .accentColor(.white)
                            Text("18")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 40)
                        
                        // Additional Controls
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                            Spacer()
                            Text("Bedroom")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 40)

                        Spacer()
                    }
                )
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
