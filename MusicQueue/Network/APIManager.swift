//
//  API.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-27.
//
import SwiftUI

protocol APIManagerProtocol {
    func createSessionRequest(hostId: String, sessionName: String) async throws -> ResponseProtocol
}

class APIManager: APIManagerProtocol {
    @Injected private var logger: CustomLoggerProtocol
    
    private let baseUrl: String = "http://192.168.1.160:3000"
    private let createSessionUrl = "/api/create-session"
    
    func createSessionRequest(hostId: String, sessionName: String) async throws -> ResponseProtocol {
        guard let url = URL(string: baseUrl + createSessionUrl) else {
            let error = CustomURLError(message: "Bad URL: \(baseUrl + createSessionUrl)")
            logger.error("Failed to create URL.")
            throw error
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createSessionRequest = CreateSessionRequest(hostId: hostId, sessionName: sessionName)
        do {
            request.httpBody = try JSONEncoder().encode(createSessionRequest)
        } catch {
            let error = EncodingError(message: "Failed to encode createSessionRequest: \(createSessionRequest)")
            logger.error(error.message)
            throw error
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decodedResponse = try JSONDecoder().decode(CreateSessionResponse.self, from: data)
            return decodedResponse
        } catch {
            let error = SerializationError(message: "Unable to decode response.")
            throw error
        }
    }
}
