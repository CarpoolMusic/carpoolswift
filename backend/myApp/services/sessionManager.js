// SessionManager.js

const uuid = require('uuid');

class SessionManager {
    constructor() {
        if (!SessionManager.instance) {
            this.sessions = new Map();
            SessionManager.instance = this;
        }
        return SessionManager.instance;
    }

    createSession(userID) {
        // Generate a unique session ID
        const sessionID = uuid.v4();

        // Create a new session
        const session = {
        id: sessionID,
        host: userID,
        members: new Set(),
        queue: [],
        };

        // Add the session to the map of active sessions
        this.sessions.set(sessionID, session);

        return sessionID;
    }

    getSession(sessionID) {
        return this.sessions.get(sessionID);
    }

    deleteSession(sessionID) {
        this.sessions.delete(sessionID);
    }
}

const instance = new SessionManager();
Object.freeze(instance);
  
module.exports = instance;