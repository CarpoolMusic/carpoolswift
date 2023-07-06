//
//  Session.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import Foundation

class SessionManager {
    // MARK: - State
    
    var sessionID: Int
    private var users: [User]
    private var sessionAdmin: User?

    init() {
        self.sessionID = 0
        self.users = []
        self.sessionAdmin = nil
    }
    
    //MARK: - Methods

    func joinSession(user: User) {
        users.append(user)
    }

    func leaveSession(user: User) {
//        users.removeAll { $0.id == user.id }
//        if let admin = sessionAdmin, admin.id == user.id {
//            sessionAdmin = nil
//            // Perform logic to assign a new session admin if needed
//        }
    }

    func assignSessionAdmin(admin: User) {
        sessionAdmin = admin
    }

    func getSessionUsers() -> [User] {
        return users
    }

    func getSessionAdmin() -> User? {
        return sessionAdmin
    }
}
