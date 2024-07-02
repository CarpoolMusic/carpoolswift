//
//  API.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-27.
//
import SwiftUI

protocol APIManagerProtocol {
    func createAccountRequest(email: String, username: String?, passsword: String) async throws -> ResponseProtocol
    func loginRequest(idenitifier: String, password: String) async throws -> ResponseProtocol
    func createSessionRequest(hostId: String, sessionName: String) async throws -> ResponseProtocol
}

// Implementation of API manager
class APIManager: APIManagerProtocol {
    @Injected private var logger: CustomLoggerProtocol
    
    private let baseUrl: String = "http://192.168.1.160:3000"
    private let createSessionUrl = "/api/create-session"
    private let loginUrl = "/api/login"
    private let signUpUrl = "/api/createAccount"
    
    func createAccountRequest(email: String, username: String?, passsword: String) async throws -> ResponseProtocol {
        guard let url = URL(string: baseUrl + signUpUrl) else {
            let error = CustomURLError(message: "Bad URL: \(baseUrl + signUpUrl)")
            logger.error(error.message)
            throw error
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createAccountRequest = CreateAccountRequest(email: email, username: username, password: passsword)
        do {
            request.httpBody = try JSONEncoder().encode(createAccountRequest)
        } catch {
            let error = EncodingError(message: "Failed to encode createAccountRequest: \(createAccountRequest)")
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
                let decodedResponse = try JSONDecoder().decode(CreateAccountResponse.self, from: data)
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
    
    func loginRequest(idenitifier identifier: String, password: String) async throws -> ResponseProtocol {
        guard let url = URL(string: baseUrl + loginUrl) else {
            let error = CustomURLError(message: "Bad URL: \(baseUrl + loginUrl)")
            logger.error(error.message)
            throw error
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(identifier: identifier, password: password)
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            let error = EncodingError(message: "Failed to encode loginRequest: \(loginRequest)")
            logger.error(error.message)
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorMessage = "HTTP Error: \(httpResponse.statusCode). Response: \(String(data: data, encoding: .utf8) ?? "No response body")"
                logger.error(errorMessage)
                throw CustomURLError(message: errorMessage)
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
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

    func createSessionRequest(hostId: String, sessionName: String) async throws -> ResponseProtocol {
        guard let url = URL(string: baseUrl + createSessionUrl) else {
            let error = CustomURLError(message: "Bad URL: \(baseUrl + createSessionUrl)")
            logger.error(error.message)
            throw error
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let data = KeychainHelper.standard.read(service: "com.poles.carpoolapp", account: "accessToken"), let accessToken = String(data: data, encoding: .utf8 ) else {
            let error = KeychainHelperError(message: "Unable to read access token")
            logger.error(error)
            throw error
        }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
