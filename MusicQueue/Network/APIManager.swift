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

// Implementation of API manager
class APIManager: APIManagerProtocol {
    @Injected private var logger: CustomLoggerProtocol
    
    private let baseUrl: String = "http://192.168.1.160:3000"
    private let createSessionUrl = "/api/create-session"
    
    func createSessionRequest(hostId: String, sessionName: String) async throws -> ResponseProtocol {
        guard let url = URL(string: baseUrl + createSessionUrl) else {
            let error = CustomURLError(message: "Bad URL: \(baseUrl + createSessionUrl)")
            logger.error(error.message)
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
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                let errorMessage = "HTTP Error: \(httpResponse.statusCode). Response: \(String(data: data, encoding: .utf8) ?? "No response body")"
                logger.error(errorMessage)
                throw CustomURLError(message: errorMessage)
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CreateSessionResponse.self, from: data)
                return decodedResponse
            } catch {
                let errorMessage = "Unable to decode response. Data: \(String(data: data, encoding: .utf8) ?? "Invalid data"). Error: \(error)"
                logger.error(errorMessage)
                throw SerializationError(message: errorMessage)
            }
        } catch {
            // Print the error details
            logger.error("Request failed with error: \(error.localizedDescription)")
            
            if let urlError = error as? URLError {
                logger.error("URLError: \(urlError)")
                logger.error("URLError code: \(urlError.code)")
            }
            throw error
        }
    }
}
