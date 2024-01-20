//
//  EventReciever.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-19.
//

import Foundation

extension SessionManager {
    
    func handleEvent(event: String, items: [Any]) {
            print("EVENT ", event)
            switch event {
            case "sessionCreated":
                print("Session created")
                handleCreateSessionResponse(items: items)
            case "sessionJoined":
                print("Session joined")
                handleJoinSessionResponse(items: items)
            case "songAdded":
                print("Song Added")
                handleSongAddedEvent(items: items)
            case "songVoted":
                print("Song voted")
                handleSongVotedEvent(items: items)
    //        case "userJoined":
    //            handleUserJoinedEvent(items: items)
    //        case "sessionLeft":
    //            self.isConnected = false
                
            default:
                print("Unhandled event: \(event)")
            }
        }
    
    func handleCreateSessionResponse(items: [Any]) {
        if let firstItem = items.first as? [String: Any] {
            if let sessionId = firstItem["sessionId"] as? String {
                self._session.sessionId = sessionId
                isActive = true
            } else if let errResponse = firstItem["error"] {
                print("Handle err", errResponse)
            } else {
                print("Unknown response")
            }
        }
    }
    
    func handleJoinSessionResponse(items: [Any]) {
        if let firstItem = items.first as? [String: Any] {
            if let users = firstItem["users"] as? [String] {
                _session.users = users
                self.isActive = true
            } else if let errResponse = firstItem["error"] {
                print("Handle err", errResponse)
            } else {
                print("Unkown response")
            }
        }
    }
    
    func handleUserJoinedEvent(items: [Any]) {
        if let firstItem = items.first as? [String: Any] {
            if let user = firstItem["user"] as? String {
                self._session.users?.append(user)
            }
        } else {
            print("Unkown event in userJoined")
        }
    }
    
    func handleSongAddedEvent(items: [Any]) {
        
        if let songItems = items.first as? [String: Any] {
            guard let song: Song = buildMusicItem(songItems: songItems) else {
                print("Cannot parse song")
                return
            }
            
            searchManager.resolveSong(song: song) { result in
                print("resovied song")
                DispatchQueue.main.async {
                    switch result {
                    case .success(let song):
                        print("Success on adding song to queue", song)
                        self._queue.enqueue(song: song)
                        self.songAdded = true
                    case .failure(let error):
                        // Handle error
                        print("Error resolving song \(error)")
                    }
                }
            }
        } else {
            print("Error in response from songAddedEvent")
        }
    }
    
    func handleSongVotedEvent(items: [Any]) {
        
        if let voteItems = items.first as? [String : Any] {
            if let songId = voteItems["songId"] as? String, let vote = voteItems["vote"] as? Int {
                if var votedSong = self._queue.find(id: songId) {
                    (vote == -1) ? votedSong.downvote() : votedSong.upvote()
                }
            }
        }
    }
  
    private func buildMusicItem(songItems: [String: Any]) -> Song? {
        if let song = songItems["song"] as? [String: Any] {
            let service = song["service"] as? String ?? ""
            let id = song["id"] as? String ?? ""
            let uri = song["uri"] as? String ?? ""
            let title = song["title"] as? String ?? ""
            let album = song["album"] as? String ?? ""
            let artist = song["artist"] as? String ?? ""
            let artworkURL = song["artworkUrl"] as? String ?? ""
            let votes = song["votes"] as? Int ?? -1
            return Song(service: service, id: id, uri: uri, title: title, artist: album, album: artist, artworkURL: artworkURL, votes: votes)
        }
        
        return nil
    }
}


