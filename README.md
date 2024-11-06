
# 🎶 Carpool iOS App

An innovative group music experience app that seamlessly integrates with Apple Music and Spotify, allowing friends to collaboratively create and enjoy music sessions, whether they're in the same room or miles apart.

---

## 📖 Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [License](#license)
- [Contributing](#contributing)

---

## Project Overview

CarpoolMusic is an iOS app designed to create a social music-sharing experience. Users can start a music session, invite friends to join, and listen together in real-time. By leveraging Apple Music and Spotify integrations, users have access to millions of songs and can control the playlist collaboratively, making every drive, gathering, or virtual hangout a synchronized musical journey.

---

## Features

- **Real-Time Music Sessions**: Host or join live music sessions to listen to songs together.
- **Cross-Platform Music Support**: Compatible with both Apple Music and Spotify.
- **Dynamic Playlists**: Easily add, reorder, or remove songs in real-time.
- **Remote and Local Syncing**: Enjoy music with friends nearby or from across the world.
- **Voting Mechanism**: Allow participants to vote on the next track.
- **Session Discovery**: Quickly find and join nearby sessions.
- **User-Friendly Interface**: Intuitive design for seamless navigation and music control.

---

## Architecture

CarpoolMusic follows a modular and scalable architecture, utilizing best practices to ensure a clean and maintainable codebase. Here’s a high-level overview of the architecture:

- **MVVM (Model-View-ViewModel)**: Ensures a clear separation between UI and business logic.
- **Network Layer**: Manages all network requests to fetch music data and sync playback states.
- **Dependency Injection**: Simplifies testing and reduces coupling between components.
- **Real-Time Communication**: Integrates WebSocket/HTTP for live music session updates.
  
### Key Components

1. **ViewModels**: Handles the logic of each screen, updates views with session data, and manages user interactions.
2. **Networking Layer**: Communicates with the backend (using REST and WebSocket protocols) to retrieve and send session data.
3. **Data Models**: Defines core entities like `User`, `Session`, and `Song`.
4. **Third-Party Integrations**: Manages the integration with Apple Music and Spotify SDKs for song playback and control.

---

## Technologies Used

- **Languages**: Swift
- **Frameworks**: SwiftUI, Combine, AVFoundation
- **Third-Party Libraries**: 
  - `Alamofire` - for networking
  - `Socket.IO` - for real-time session syncing
  - `SpotifySDK` - integration with Spotify
  - `MusicKit` - integration with Apple Music
- **APIs**: Apple Music API, Spotify API
- **Dependency Management**: Swift Package Manager

---

## Installation and Setup

To set up the CarpoolMusic iOS app locally:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/CarpoolMusic/carpoolswift.git
   cd carpoolswift
   ```

2. **Install Dependencies**:
   Ensure that Xcode is installed. Open the project workspace:
   ```bash
   open CarpoolMusic.xcodeproj
   ```
   Then use Swift Package Manager to resolve dependencies.

3. **Configure API Keys**:
   - Set up Apple Music and Spotify API credentials.
   - Create a `.env` file in the root directory with the following:
     ```plaintext
     APPLE_MUSIC_KEY=your_apple_music_key
     SPOTIFY_CLIENT_ID=your_spotify_client_id
     SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
     ```

4. **Build and Run**:
   Select your target device/simulator in Xcode and hit **Run**.

---

## Usage

1. **Sign In**: Log in using your preferred music service (Apple Music or Spotify).
2. **Create or Join a Session**: Start a new music session or join an existing one nearby.
3. **Control Playback**: Add songs, vote for the next track, or change playback settings.
4. **Invite Friends**: Share your session link with friends to let them join.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/YourFeature
   ```
3. Make changes and commit:
   ```bash
   git commit -m "Add your message here"
   ```
4. Push to your branch:
   ```bash
   git push origin feature/YourFeature
   ```
5. Open a pull request.

For major changes, please open an issue first to discuss what you would like to change.

---

Enjoy creating musical moments together with **CarpoolMusic**! 🎶
