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
                    print("RESPONSE", response as Any)
                    print("ERROR", error)
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
                        }
                        completion(.failure(SpotifySearchError.conversionError))
                        return nil
                    }
                    completion(.success(tracks))
                } catch {
                    completion(.failure(error))
                }

            }.resume()
        }
    }

struct SpotifySong {
    let id: String
    let name: String
    let uri: String
    let duration: Int
    let artists: [String]
    let albumName: String
    let artworkURL: String
    
    init(song: Song) {
        self.id = song.id
        self.name = song.title
        self.uri = song.uri
        self.duration = 0
        self.artists = [""]
        self.albumName = ""
        self.artworkURL = song.artworkURL
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String else {
            print("Missing id")
            return nil
        }
        guard let name = dictionary["name"] as? String else {
            print("Missing name")
            return nil
        }
        guard let uri = dictionary["uri"] as? String else {
            print("Missing uri")
            return nil
        }
        guard let duration = dictionary["duration_ms"] as? Int else {
            print("Missing duration")
            return nil
        }
        guard let album = dictionary["album"] as? [String: Any],
              let albumName = album["name"] as? String else {
            print("Missing album or album name")
            return nil
        }
        guard let artistsArray = dictionary["artists"] as? [[String: Any]] else {
            print("Missing artists")
            return nil
        }
        guard let imageArray = album["images"] as? [[String: Any]],
            let firstImageJson = imageArray.first,
            let artworkURL = firstImageJson["url"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.uri = uri
        self.duration = duration
        self.albumName = albumName
        self.artists = artistsArray.compactMap { $0["name"] as? String }
        self.artworkURL = artworkURL
    }
}
