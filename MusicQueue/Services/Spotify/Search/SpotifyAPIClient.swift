// MARK: - CodeAI Output

import Foundation
import os

// MARK: - CodeAI Output

class SpotifyAPIClient {
    @Injected private var logger: CustomLoggerProtocol
    
    let baseURL = "https://api.spotify.com/v1"
    var accessToken: String = ""
    
    init() {
        guard let data = KeychainHelper.standard.read(service: "com.poles.carpoolapp", account: "spotifyToken"), let accessToken = String(data: data, encoding: .utf8) else {
            let error = APIError(message: "Unable to fetch access token")
            logger.error(error)
            return
        }
        self.accessToken = accessToken
    }
    
    func sendRequest<T: Decodable>(endpoint: String, method: String, parameters: [String: Any]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            throw APIError(message: "Invalid URL")
        }
        
        if method == "GET" {
            if let parameters = parameters {
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
        }
        
        guard let url = urlComponents.url else {
            throw APIError(message: "Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        if method != "GET", let parameters = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError(message: "Invalid response \(response)")
        }
        
        if !((200...299).contains(httpResponse.statusCode)) {
            throw APIError(message: "Error response with error code \(httpResponse.statusCode), response \(httpResponse) using request \(request)")
        }
        
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
    
    
    func searchSongs(query: String, limit: Int) async throws -> [SongProtocol] {
        let parameters: [String: Any] = [
            "q": query,
            "type": "track",
            "limit": limit
        ]
        
        let searchResponse: SpotifySearchResponse = try await sendRequest(endpoint: "search", method: "GET", parameters: parameters)
        
        return searchResponse.tracks.items
    }
    
    func resolveSong(song: SongProtocol) async throws -> SongProtocol? {
        let query = createSearchQuery(from: song)
        return try await searchSongs(query: query, limit: 1).first
    }
    
    private func createSearchQuery(from song: SongProtocol) -> String {
        var queryItems = [String]()

        queryItems.append("track:\(song.songTitle)")
        queryItems.append("artist:\(song.artist)")
        queryItems.append("album:\(song.albumTitle)")

        let query = queryItems.joined(separator: " ")
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

}
