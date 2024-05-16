// MARK: - CodeAI Output
/**
 This class manages the session and connection with the server using SocketIO.
 It provides functionality to check if the user is connected, active, and if a song has been added or the queue has been updated.
 */

import Foundation
import SocketIO
import SwiftUI
import Combine
import MusicKit
import os

protocol SessionManagerProtocol: ObservableObject {
    var activeSession: Session? { get }
    
    var sessionConnectivityPublisher: PassthroughSubject<Bool, Never> { get }
    
    func createSession(hostId: String, sessionName: String) async throws -> Session
    func joinSession(sessionId: String, hostName: String) async throws
    func deleteSession(sessionId: String, hostName: String) async throws
}

/**
 The SessionManager class is an ObservableObject that manages the session and connection with the server using SocketIO.
 */
class SessionManager: SessionManagerProtocol, ObservableObject {
    @Injected private var apiManager: APIManagerProtocol
    @Injected private var logger: CustomLoggerProtocol
    
    @Published var activeSession: Session?
    
    var sessionConnectivityPublisher = PassthroughSubject<Bool, Never>()
    
    private var sessions: [String: Session] = [:]
    
    
    func createSession(hostId: String, sessionName: String) async throws -> Session {
        guard let resp = try await apiManager.createSessionRequest(hostId: hostId, sessionName: sessionName) as? CreateSessionResponse else {
            throw UnknownResponseError(message: "Unexpected response.")
        }
        
        let sessionId = resp.sessionId
        let session = Session(sessionId: sessionId, sessionName: sessionName, hostName: hostId)
        self.sessions[sessionId] = session
        self.activeSession = session
        
        return session
    }
    
    func joinSession(sessionId: String, hostName: String) async throws {
        guard let session = self.activeSession else {
            throw SessionManagerError(message: "Trying to join session with no active sessions.")
        }
        
        try await self.connect(sessionId: sessionId)
        
        let status = try await session.join(hostName: hostName)
        if (status["status"] as? String == "success") {
            sessionConnectivityPublisher.send(true)
        } else {
            throw EventError(message: "Unable to join session with error \(String(describing: status["message"]))")
        }
        
        logger.debug("Session \(sessionId) joined successfully")
    }
    
    func deleteSession(sessionId: String, hostName: String) {
    }
    
    func connect(sessionId: String) async throws {
        guard let session = self.activeSession else {
            throw SocketError(message: "Attempting to connect with no active session.")
        }
        
        try await session.connect()
    }
    
    func isConnected() -> Bool {
        guard let session = self.activeSession else {
            return false
        }
        
        return session.isConnected()
    }
    
}
