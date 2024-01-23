//
//  EventReciever.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-19.
//

import Foundation

extension SessionManager {
    
    func handleEvent(event: String, items: [Any]) {
        switch event {
        case "sessionCreated":
            handleCreateSessionResponse(items: items)
        case "sessionJoined":
            handleJoinSessionResponse(items: items)
        case "songAdded":
            handleSongAddedEvent(items: items) { result in
                switch result {
                case .success(let song):
                    self.logger.log(level: .debug, "Song with id \(song.id) was added to the queue.")
                case .failure(let error):
                    self.logger.log(level: .error, "\(error)")
                }
            }
        case "songRemoved":
            handleSongRemovedEvent(items: items)
        case "songVoted":
            handleSongVotedEvent(items: items)
        default:
            print("Unhandled event: \(event)")
        }
    }
    
    func handleCreateSessionResponse(items: [Any]) {
        do {
            if let firstItem = items.first as? [String: Any] {
                if let sessionId = firstItem["sessionId"] as? String {
                    self._session.sessionId = sessionId
                    isActive = true
                } else if let errResponse = firstItem["error"] as? String {
                    throw EventError(message: errResponse, stacktrace: Thread.callStackSymbols)
                } else {
                    throw UnkownError(stacktrace: Thread.callStackSymbols)
                }
            }
            
        } catch let error as EventError {
            ErrorToast.shared.showToast(message: "Unable to create session.")
            logger.log(level: .error, "\(error.toString())")
        } catch let error as UnkownError {
            logger.log(level: .fault, "\(error.toString())")
            fatalError(error.toString())
        } catch {
            logger.log(level: .fault, "\(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    func handleJoinSessionResponse(items: [Any]) {
        do {
            guard let firstItem = items.first as? [String : Any] else {
                throw UnkownError(stacktrace: Thread.callStackSymbols)
            }
            guard let users = firstItem["users"] as? [String] else {
                throw UnkownResponseError(message: "Expected handleJoinSessionResponse but got \(firstItem) instead", stacktrace: Thread.callStackSymbols)
            }
            if let errResponse = firstItem["error"] as? String {
                throw EventError(message: errResponse, stacktrace: Thread.callStackSymbols)
            }
            
            _session.users = users
            self.isActive = true
            
        } catch let error as UnkownError {
            logger.log(level: .fault, "\(error.toString())")
            fatalError(error.toString())
        } catch let error as UnkownResponseError {
            logger.log(level: .fault, "\(error.toString())")
            fatalError(error.toString())
        } catch let error as EventError {
            logger.log(level: .error, "\(error.toString())")
            ErrorToast.shared.showToast(message: "Unable to create session.")
        } catch {
            logger.log(level: .fault, "\(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    func handleUserJoinedEvent(items: [Any]) throws {
        do {
            guard let firstItem = items.first as? [String : Any] else {
                throw UnkownError(stacktrace: Thread.callStackSymbols)
            }
            guard let user = firstItem["user"] as? String else {
                throw UnkownResponseError(message: "Expected handleJoinSessionResponse but got \(firstItem) instead", stacktrace: Thread.callStackSymbols)
            }
            if let errResponse = firstItem["error"] as? String {
                throw EventError(message: "Unexpected repsonse \(errResponse) from userJoinedEvent", stacktrace: Thread.callStackSymbols)
            }
            
            _session.users.append(user)
            
        } catch let error as EventError {
            logger.log(level: .error, "\(error.toString())")
            ErrorToast.shared.showToast(message: "Unable to create session.")
        }  catch let error as CustomError {
            logger.log(level: .fault, "\(error.toString())")
            fatalError(error.toString())
        } catch {
            logger.log(level: .fault, "\(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    func handleSongAddedEvent(items: [Any], completion: @escaping (Result<AnyMusicItem, Error>) -> Void) {
        
        guard let songItems = items.first as? [String : Any] else {
            completion(.failure(UnkownError(stacktrace: Thread.callStackSymbols)))
            return
        }
        
        do {
            let song = try buildMusicItem(songItems: songItems)
            let searchManager = UserPreferences.getUserMusicService() == .apple ? SearchManager(AppleMusicSearchManager()) : SearchManager(SpotifySearchManager())
            searchManager.resolveSong(song: song) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let song):
                        self._queue.enqueue(song: song)
                        self.songAdded = true
                        completion(.success(song))
                    case .failure(let error):
                        let resolutionError = SongResolutionError(message: "Cannot resolve song \(song). Error \(error)", stacktrace: Thread.callStackSymbols)
                        completion(.failure(resolutionError))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func handleSongRemovedEvent(items: [Any]) {
        do {
            guard let items = items.first as? [String : Any] else {
                throw UnkownError(stacktrace: Thread.callStackSymbols)
            }
            guard let songId = items["songId"] as? String else {
                throw UnkownResponseError(message: "No songId in response: \(items)", stacktrace: Thread.callStackSymbols)
            }
            
            self._queue.removeItem(id: songId)
            
        } catch {
            logger.log(level: .fault, "\(error)")
            fatalError(error.localizedDescription)
        }
    }
        
    func handleSongVotedEvent(items: [Any]) {
        do {
            guard let voteItems = items.first as? [String : Any] else {
                throw UnkownError(stacktrace: Thread.callStackSymbols)
            }
            guard let songId = voteItems["songId"] as? String, let vote = voteItems["vote"] as? Int else {
                throw UnkownResponseError(message: "Unexpected response \(voteItems)", stacktrace: Thread.callStackSymbols)
            }
            guard var votedSong = self._queue.find(id: songId) else {
                throw EventError(message: "Song with id \(songId) not found in queue", stacktrace: Thread.callStackSymbols)
            }
            
            (vote == -1) ? votedSong.downvote() : votedSong.upvote()
            
        } catch let error as EventError {
            ErrorToast.shared.showToast(message: "Voted on song is not in queue")
            logger.log(level: .error, "\(error.toString())")
        } catch let error as CustomError {
            logger.log(level: .fault, "\(error.toString())")
            fatalError(error.toString())
        }  catch {
            logger.log(level: .fault, "\(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildMusicItem(songItems: [String: Any]) throws -> Song {
        guard let songJson = songItems["song"] as? [String: Any] else {
            throw SongConversionError(message: "Unable to get songJson for items \(songItems)", stacktrace: Thread.callStackSymbols)
        }
        guard let service = songJson["service"] as? String,
              let id = songJson["id"] as? String,
              let uri = songJson["uri"] as? String,
              let title = songJson["title"] as? String,
              let album = songJson["album"] as? String,
              let artist = songJson["artist"] as? String,
              let artworkURL = songJson["artworkUrl"] as? String,
              let votes = songJson["votes"] as? Int else {
            
            throw SongConversionError(message: "Unable to convert song JSON to song for JSON \(songJson)", stacktrace: Thread.callStackSymbols)
        }
        return Song(service: service, id: id, uri: uri, title: title, artist: album, album: artist, artworkURL: artworkURL, votes: votes)
    }
}


