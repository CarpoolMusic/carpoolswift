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

protocol SessionManagerProtocol {
    func createSession(hostId: String, sessionName: String, completion: @escaping (Result<String, Error>) -> Void)
    func joinSession(sessionId: String, hostName: String) throws
    func deleteSession(sessionId: String, hostName: String) throws
}

/**
 The SessionManager class is an ObservableObject that manages the session and connection with the server using SocketIO.
 */
class SessionManager: SessionManagerProtocol, ObservableObject {
    @Injected private var apiManager: APIManagerProtocol
    @Injected private var logger: Logger
    
    
    private var activeSessionId: String = ""
    private var sessions: [String: Session] = [:]
    
    func createSession(hostId: String, sessionName: String, completion: @escaping (Result<String, Error>) -> Void) {
        apiManager.createSessionRequest(hostId: hostId, sessionName: "Test") { [weak self] result in
            switch result {
            case .success(let createSessionResponse):
                let sessionId = createSessionResponse.sessionId
                self?.sessions[sessionId] = Session(sessionId: sessionId, sessionName: sessionName, hostName: hostId)
                completion(.success(sessionId))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func joinSession(sessionId: String, hostName: String) {
    }
    
    func deleteSession(sessionId: String, hostName: String) {
    }
    
    func getActiveSession() -> Session? {
        return sessions[activeSessionId]
    }
}
