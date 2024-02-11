# Carpool iOS App

## Overview
MusicQueue is a cross-platform participatory music queueing application designed to integrate seamlessly with major music streaming services like Apple Music and Spotify. The app allows users to collectively manage a music playlist in real-time, making it ideal for parties, group gatherings, or collaborative listening sessions.

## Features
- **Real-Time Music Sessions**: Create or join music sessions where participants can add songs to a shared queue. Supports both local and remote sessions. A local session is where only the session admins devices plays the music. Remote is when all devices connected to the session play music.
- **Cross-Platform Streaming Service Integration**: Supports Apple Music and Spotify, allowing users to add songs from either service to the shared queue.
- **Voting System**: Users can vote on songs in the queue, influencing the order of playback.
- **Admin Controls**: Session creators have administrative privileges to manage the queue and participants.
- **User Profile Management**: Users can create and manage their profiles, including music preferences and service integrations.

## Upcoming Features
- ** Persistent "listening rooms" where users can create persistent rooms and join/unjoin
- ** Live feed where users can see what listening rooms there friends are in
- ** Session statistics such as best/worst contributor, best/worst songs etc. 
- ** Chat Feature

## View Components

### 1. AuthorizationView
Handles the authentication and authorization process for Apple Music and Spotify. Ensures secure and seamless access to user's music accounts.

### 2. SessionCreationView
Allows users to create new music sessions, setting parameters like session name, privacy settings, and allowed streaming services.

### 3. SessionView
Displays the current music session with real-time updates to the music queue. Participants can add songs, vote on the queue, and view current playing track.

### 4. NowPlayingView
Shows the currently playing song with controls for play, pause, skip, and volume adjustments. Displays song information including title, artist, and album art.

### 5. QueueView
Presents the upcoming songs in the queue. Users can add songs to the queue from Apple Music or Spotify libraries.
