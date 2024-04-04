//
//  API.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-27.
//

import Foundation

protocol APIManagerProtocol {
    func createSessionRequest(hostId: String, sessionName: String, completion: @escaping (Result<CreateSessionResponse, Error>) -> Void)
}

class APIManager: APIManagerProtocol {
    private let baseUrl: String = "http://localhost:300"
    private let createSessionUrl = "/create-session"
    
    func createSessionRequest(hostId: String, sessionName: String, completion: @escaping (Result<CreateSessionResponse, Error>) -> Void) {
        guard let url = URL(string: baseUrl + createSessionUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createSessionRequest = CreateSessionRequest(hostId: hostId, sessionName: sessionName)
        do {
            request.httpBody = try JSONEncoder().encode(createSessionRequest)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CreateSessionResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
