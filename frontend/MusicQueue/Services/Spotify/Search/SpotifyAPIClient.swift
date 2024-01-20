//
//  SpotifyAPIClient.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-12-05.
//

import Foundation

enum SpotifySearchError: Error {
    case conversionError
}

class SpotifyAPIClient {
    let baseURL = "https://api.spotify.com/v1"
    let accessToken: String

    init() {
        if let token = TokenVault.getTokenFromKeychain() {
            self.accessToken = token
        } else {
            self.accessToken = ""
            print("Unable to get access token")
        }
    }
    
    func searchSongs(query: String, limit: Int, completion: @escaping (Result<[AnyMusicItem], Error>) -> Void) {
        let url = "\(baseURL)/search?type=track&limit=\(limit)&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("URL:", url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }

                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    guard let tracksDict = jsonDict?["tracks"] as? [String: Any],
                          let items = tracksDict["items"] as? [[String: Any]] else {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid or missing data in JSON"])
                    }
                    
                    let tracks = items.compactMap {
                        if let song = SpotifySong(dictionary: $0) {
                            return AnyMusicItem(song)
                        } else {
                            completion(.failure(SpotifySearchError.conversionError))
                            return nil
                        }
                    }
                    completion(.success(tracks))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
