//
//  SocketEventReciever.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import SocketIO
import os

class SocketEventReceiver {
    @Injected private var notificationCenter: NotificationCenterProtocol
    private var logger = Logger()
    
    private var socket: SocketIOClient
    
    init(socket: SocketIOClient) {
        self.socket = socket
    }
    
    func receivedEvent(event: String, with items: [Any]) {
        switch event {
        case "sessionCreated":
            handleSessionCreatedEvent(items: items)
        case "sessionJoined":
            handleSessionJoinedEvent(items: items)
        case "userJoined":
            handleUserJoinedEvent(items: items)
        case "songAdded":
            notificationCenter.post(name: .songAddedNotification, object: items)
        case "songRemoved":
            notificationCenter.post(name: .songRemovedNotification, object: items)
        case "songVoted":
            notificationCenter.post(name: .songVotedNotification, object: items)
        default:
            print("Unhandled event: \(event)")
        }
    }
    
    func handleSessionCreatedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .sessionCreatedNotification, error)
            return
        }
        
        if let sessionId = firstItem["sessionId"] as? String {
            postResponse(from: .sessionCreatedNotification, sessionId)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .sessionCreatedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .sessionCreatedNotification, error)
        }
    }
    
    func handleSessionJoinedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .sessionJoinedNotification, error)
            return
        }
        
        if let users = firstItem["users"] as? [String] {
            postResponse(from: .sessionJoinedNotification, users)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .sessionJoinedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .sessionJoinedNotification, error)
        }
    }
    
    func handleUserJoinedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Failed to deserialize items")
            postError(causedBy: .userJoinedNotification, error)
            return
        }
        
        if let user = firstItem["user"] as? String {
            postResponse(from: .userJoinedNotification, user)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .userJoinedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .userJoinedNotification, error)
        }
    }
    
    func handleSongAddedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Unable to deserialize response")
            postError(causedBy: .songAddedNotification, error)
            return
        }

        do {
            let song = try buildMusicItem(songItems: firstItem)
            resolveSong(song) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let resolvedSong):
                        self?.postResponse(from: .songAddedNotification, resolvedSong)
                        self?.postResponse(from: .queueUpdatedNotification)
                    case .failure(let error):
                        self?.postError(causedBy: .songAddedNotification, error as! CustomError)
                    }
                }
            }
        } catch let error as CustomError {
            postError(causedBy: .songAddedNotification, error)
        } catch {
            logger.fault("Unkown error")
        }
    }
    
    func handleSongRemovedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Unable to deserialize response")
            postError(causedBy: .songRemovedNotification, error)
            return
        }
        
        if let songId = firstItem["songId"] as? String {
            postResponse(from: .songRemovedNotification, songId)
            postResponse(from: .queueUpdatedNotification)
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .songRemovedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .songRemovedNotification, error)
        }
    }
    
    func handleSongVotedEvent(items: [Any]) {
        guard let firstItem = items.first as? [String: Any] else {
            let error = SerializationError(message: "Unable to deserialize response")
            postError(causedBy: .songVotedNotification, error)
            return
        }
        
        if let songId = firstItem["songId"] as? String, let vote = firstItem["vote"] as? Int {
            postResponse(from: .songVotedNotification, (songId, vote))
        } else if let errorMessage = firstItem["error"] as? String {
            let error = EventError(message: errorMessage)
            postError(causedBy: .songVotedNotification, error)
        } else {
            let error = UnkownError()
            postError(causedBy: .songVotedNotification, error)
        }
    }
    
    
    // MARK: - Helper functions
    private func resolveSong(_ song: Song, completion: @escaping (Result<AnyMusicItem, any Error>) -> Void) {
        let searchManager = UserPreferences.getUserMusicService() == .apple ? SearchManager(AppleMusicSearchManager()) : SearchManager(SpotifySearchManager())

        searchManager.resolveSong(song: song) { result in
            completion(result)
        }
    }
    
    private func buildMusicItem(songItems: [String: Any]) throws -> Song {
        guard let songJson = songItems["song"] as? [String: Any] else {
            throw SongConversionError(message: "Unable to get songJson for items \(songItems)", stacktrace: Thread.callStackSymbols)
        }
        
        guard let id = songJson["id"] as? String,
              let appleID = songJson["appleID"] as? String,
              let spotifyID = songJson["spotifyID"] as? String,
              let uri = songJson["uri"] as? String,
              let title = songJson["title"] as? String,
              let album = songJson["album"] as? String,
              let artist = songJson["artist"] as? String,
              let artworkURL = songJson["artworkUrl"] as? String,
              let votes = songJson["votes"] as? Int else {
            
            throw SongConversionError(message: "Unable to convert song JSON to song for JSON \(songJson)", stacktrace: Thread.callStackSymbols)
        }
        
        return Song(id: id, appleID: appleID, spotifyID: spotifyID, uri: uri, title: title, artist: album, album: artist, artworkURL: artworkURL, votes: votes)
    }
    
    private func postResponse(from notificationName: Notification.Name) {
        notificationCenter.post(name: notificationName, object: nil)
        logger.debug("Posted notificaiton ")
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: String) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: [String]) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: AnyMusicItem) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
        logger.debug("Posted notificaiton ")
    }
    
    private func postResponse(from notificationName: Notification.Name, _ response: (String, Int)) {
        notificationCenter.post(name: notificationName, object: response)
        logger.debug("Posted notificaiton ")
        logger.debug("Posted notificaiton ")
    }
    
    
    private func postError(causedBy notificationName: Notification.Name, _ error: CustomError) {
        notificationCenter.post(name: notificationName, object: error)
        logger.error(error.message)
    }
}
