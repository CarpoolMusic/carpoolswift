// MARK: - CodeAI Output
/**
 This code is a Swift implementation of a Spotify API client. It provides functionality to search for songs using the Spotify API.
 
 The code is organized into the following sections:
 - `SpotifyAPIClient` struct: Represents the Spotify API client and contains methods for searching songs.
 - `makeUrl(limit:query:)` private function: Constructs the URL for the search request based on the provided limit and query parameters.
 - `searchSongs(query:limit:completion:)` function: Performs a search request to the Spotify API using the constructed URL and returns the search results as an array of `AnyMusicItem` objects.
 
 The code also uses a `Logger` class to log messages at different levels (debug, error, fault).
 */

import Foundation
import os

// MARK: - CodeAI Output

struct SpotifyAPIClient {
    let logger = Logger()
    let baseURL = "https://api.spotify.com/v1"
    let accessToken: String
    
    /**
     Initializes a new instance of `SpotifyAPIClient`.
     
     The access token is fetched from the Keychain using `TokenVault.getTokenFromKeychain()`. If no access token is found, an error message is logged.
     */
    init() {
        self.accessToken = TokenVault.getTokenFromKeychain() ?? ""
        if self.accessToken.isEmpty {
            logger.log(level: .error, "Unable to fetch access token")
        } else {
            logger.log(level: .debug, "Token fetched")
        }
    }
    
    /**
     Constructs the URL for the search request based on the provided limit and query parameters.
     
     - Parameters:
        - limit: The maximum number of results to return.
        - query: The search query string.
     
     - Returns: The constructed URL as a string.
     */
    private func makeUrl(limit: Int, query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(baseURL)/search?type=track&limit=\(limit)&q=\(encodedQuery)"
    }
    
    /**
     Performs a search request to the Spotify API using the constructed URL and returns the search results as an array of `AnyMusicItem` objects.
     
     - Parameters:
        - query: The search query string.
        - limit: The maximum number of results to return.
        - completion: A closure to be called with the search results or an error.
     */
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        let url = makeUrl(limit: limit, query: query)
        
        guard let requestUrl = URL(string: url) else {
            let searchError = SearchError(message: "Invalid URL", stacktrace: Thread.callStackSymbols)
            logger.log(level: .error, "\(searchError.toString())")
            completion(.failure(searchError))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let searchError = SearchError(message: error.localizedDescription, stacktrace: Thread.callStackSymbols)
                self.logger.log(level: .error, "\(searchError.toString())")
                completion(.failure(searchError))
                return
            }
            
            guard let data = data else {
                let searchError = SearchError(message: "Data in response is empty.", stacktrace: Thread.callStackSymbols)
                self.logger.log(level: .error, "\(searchError.toString())")
                completion(.failure(searchError))
                return
            }
            
            do {
                guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    throw SerializationError(message: "Unable to serialize JSON from response data \(data)", stacktrace: Thread.callStackSymbols)
                }
                
                guard let tracksDict = jsonDict["tracks"] as? [String: Any] else {
                    throw UnknownResponseError(message: "Unexpected data in response \(jsonDict)", stacktrace: Thread.callStackSymbols)
                }
                
                guard let items = tracksDict["items"] as? [[String: Any]] else {
                    throw UnknownResponseError(message: "Unexpected items in data \(jsonDict)", stacktrace: Thread.callStackSymbols)
                }
                
                let tracks = try items.compactMap { item in
                    guard let song = SpotifySong(dictionary: item) else {
                        throw SongConversionError(message: "Unable to convert to SpotifySong for item", stacktrace: Thread.callStackSymbols)
                    }
                    return AnyMusicItem(song)
                }
                
                completion(.success(tracks))
            } catch let error as CustomError {
                self.logger.log(level: .error, "\(error.toString())")
                completion(.failure(error))
            } catch {
                self.logger.log(level: .fault, "Unhandled error \(error.localizedDescription)")
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
}
