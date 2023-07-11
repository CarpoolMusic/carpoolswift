const Session = require('../models/session');

class SessionManager {
    constructor() {
        if (!SessionManager.instance) {
            this.sessions = new Map();
            SessionManager.instance = this;
        }
        return this; 
    }

    createSession(userId) {
        // Create a new session
        const session = new Session(userId);

        // Add the session to the map of active sessions
        this.sessions.set(session.sessionId, session);

        return session.sessionId;
    }

    getSession(sessionId) {
        return this.sessions.get(sessionId);
    }

    deleteSession(sessionID) {
        this.sessions.delete(sessionID);
    }
}

const instance = new SessionManager();
Object.freeze(instance);
  
module.exports = instance;