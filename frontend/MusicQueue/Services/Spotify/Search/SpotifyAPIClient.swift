//
//  SpotifyAPIClient.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-12-05.
//

import Foundation
import os

enum SpotifySearchError: Error {
    case conversionError
}

class SpotifyAPIClient {
    let logger = Logger()
    
    let baseURL = "https://api.spotify.com/v1"
    let accessToken: String
    
    init() {
        if let token = TokenVault.getTokenFromKeychain() {
            logger.log(level: .debug, "Token fetched: \(token)")
            self.accessToken = token
        } else {
            self.accessToken = ""
            // Ideally we should prompt for reauthentication here
            logger.log(level: .error, "Unable to fetch access token")
        }
    }
    
    private func _makeUrl(limit: Int, query: String) -> String {
        return "\(baseURL)/search?type=track&limit=\(limit)&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        let url = _makeUrl(limit: limit, query: query)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        logger.log(level: .debug, "Request: \(request)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let searchError = SearchError(message: error.localizedDescription, stacktrace: Thread.callStackSymbols)
                self.logger.log(level: .error, "\(searchError.toString())")
                completion(.failure(searchError))
                return
            }
            
            guard let data = data else {
                let searchError = SearchError(message: "Data in response \(String(describing: response)) is empty.", stacktrace: Thread.callStackSymbols)
                self.logger.log(level: .error, "\(searchError.toString())")
                completion(.failure(searchError))
                return
            }
            
            do {
                guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]else {
                    throw SerializationError(message: "Unable to serialize to JSON from response data \(data)", stacktrace: Thread.callStackSymbols)
                }
                guard let tracksDict = jsonDict["tracks"] as? [String: Any] else {
                    let dataString = String(data: data, encoding: .utf8)
                    throw UnkownResponseError(message: "Unexpected data \(String(describing: dataString)) \nIn response \(String(describing: response)) \n For request \(request)", stacktrace: Thread.callStackSymbols)
                }
                guard let items = tracksDict["items"] as? [[String: Any]] else {
                    throw UnkownResponseError(message: "Unexpected items \(tracksDict) in data \(data)", stacktrace: Thread.callStackSymbols)
                }
                
                let tracks = try items.compactMap {
                    guard let song = SpotifySong(dictionary: $0) else {
                        throw SongConversionError(message: "Unable to convert to SpotifySong for item \($0)", stacktrace: Thread.callStackSymbols)
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
