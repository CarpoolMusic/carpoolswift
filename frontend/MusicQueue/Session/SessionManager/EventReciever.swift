/**
 
The provided Swift code is an extension of the `SessionManager` class. It includes several methods for handling different events related to a session. Here is the documentation for each method:

1. `handleEvent(event: String, items: [Any])`: This method takes in an event name and an array of items as parameters. It switches on the event name and calls the appropriate handler method based on the event.

2. `handleCreateSessionResponse(items: [Any])`: This method handles the "sessionCreated" event. It expects an array of items containing information about the session creation response. If the response contains a valid session ID, it sets the session ID and marks the session as active. If there is an error in the response, it throws an `EventError` with the error message.

3. `handleJoinSessionResponse(items: [Any])`: This method handles the "sessionJoined" event. It expects an array of items containing information about the session join response. If the response contains a list of users, it sets the users in the session and marks it as active. If there is an error in the response, it throws an `EventError` with the error message.

4. `handleUserJoinedEvent(items: [Any]) throws`: This method handles the "userJoined" event. It expects an array of items containing information about a user joining a session. If there is a valid user in the response, it adds that user to the session's list of users.

5. `handleSongAddedEvent(items: [Any], completion: @escaping (Result<AnyMusicItem, Error>) -> Void)`: This method handles the "songAdded" event. It expects an array of items containing information about a song being added to a queue and a completion closure to handle asynchronous operations related to resolving and adding songs to the queue.

6. `handleSongRemovedEvent(items: [Any])`: This method handles the "songRemoved" event. It expects an array of items containing information about a song being removed from the queue. It removes the song from the queue based on its ID.

7. `handleSongVotedEvent(items: [Any])`: This method handles the "songVoted" event. It expects an array of items containing information about a song being voted on. It finds the song in the queue based on its ID and updates its vote count based on the vote value.

8. `buildMusicItem(songItems: [String: Any]) throws -> Song`: This is a private helper method used by `handleSongAddedEvent` to build a `Song` object from a dictionary of song items. It extracts various properties from the dictionary and creates a `Song` object with those properties.

Note: The code includes error handling using custom error types (`EventError`, `UnkownError`, etc.) and logging using a logger instance.
 */
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
            guard let firstItem = items.first as? [String: Any] else {
                throw UnkownError(stacktrace: Thread.callStackSymbols)
            }
            
            if let sessionId = firstItem["sessionId"] as? String {
                self._session.sessionId = sessionId
                isActive = true
            } else if let errResponse = firstItem["error"] as? String {
                throw EventError(message: errResponse, stacktrace: Thread.callStackSymbols)
            } else {
                throw UnkownError(stacktrace: Thread.callStackSymbols)
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
                    case .success(let resolvedSong):
                        self._queue.enqueue(newElement: resolvedSong)
                        self.songAdded = true
                        completion(.success(resolvedSong))
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
}
