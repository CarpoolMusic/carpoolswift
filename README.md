# SPEC-<n>: MusicQueue App

## Background

The creation of the MusicQueue application stems from the need for a more inclusive and democratic way to enjoy music in group settings, accommodating both local gatherings and remote, distributed groups. Traditional music playing methods often fail to cater to the diverse tastes of all participants, leading to an unbalanced experience. MusicQueue addresses this by integrating popular music services like Apple Music and Spotify and by facilitating group participation in music selection, whether participants are sharing a physical space or connecting from different locations.

## Requirements

### Must Have (MoSCoW)
- Integration with Apple Music and Spotify to access users' personal music libraries.
- Functionality for users to create or join real-time music sessions, distinguishable into two types:
  - **Local Sessions:** Designed for users in the same physical location. Only the device connected to a speaker plays music, while other participants contribute to the music queue.
  - **Remote Sessions:** Catering to users not in the same location. Each participant's device plays music, ensuring everyone can listen synchronously while interacting with the session.
- A voting system where songs can be upvoted or downvoted by participants to organize the queue.
- Administrative controls for session creators, including song removal, skipping, and participant management.
- The use of unique session codes for joining sessions.
- User profiles and settings management, including connected music service accounts.

### Should Have
- A user-friendly interface designed with SwiftUI for a seamless iOS experience.
- Real-time updates to the music queue as votes are cast.
- Automatic adjustment of playback to ensure synchronization across all participant devices in remote sessions.

### Could Have
- Recommendations for songs to add to the queue based on the collective tastes of session participants.
- Integration with more music streaming services beyond Apple Music and Spotify for greater accessibility.

### Won't Have (initially)
- Cross-platform support for Android or web, focusing initially on iOS development.
- Offline functionality for music sessions.

