const SessionManager = require('./sessionManager');

module.exports = function (io) {
    io.on('connection', (socket) => {
        console.log('clientConnected');

        // SOCKET EVENTS

        // When a user connects to the socket
        socket.emit('connected', { status: 'connected' });

        // When a user creates a session
        socket.on('create session', (userID) => {
            const sessionID = SessionManager.createSession(userID);

            // Join the user to the session room
            socket.join(sessionID);

            // Send the session ID back to the client
            socket.emit('session created', sessionID);
        });

        // When a user wants to join a session
        socket.on('join session', (sessionID) => {
            const session = SessionManager.getSession(sessionID);

            if (session) {
                socket.join(sessionID);
                socket.emit('session joined', sessionID);
            } else {
                socket.emit('error', 'Invalid session ID');
            }
        });

        // When a user wants to leave a session (non-admin)
        socket.on('leave session', (sessionID) => {
            const session = SessionManager.getSession(sessionID);
            console.log("ID2", sessionID);
            console.log("SES2", session);

            if (session) {
                if (session.members.has(socket.id) && session.host != socket.id) {
                    socket.leave(sessionID);
                    SessionManager.removeMemberFromSession(sessionID, socket.id); // Remove member from session

                    socket.emit('left session', sessionID); // Notify the user they've left the session
                    io.in(sessionID).emit('member left', socket.id); // Notify others in the room that a member has left
                } else {
                    socket.emit('permissions error', 'You are not a member of this session or you are the host of this session. If you are the host you must delete the session to leave or make another member host');
                }
            } else {
                socket.emit('error', 'Invalid session ID');
            }
        });

        // When a user wants to delete a session
        socket.on('delete session', ({ userID, sessionID }) => {
            const session = SessionManager.getSession(sessionID);

            if (session) {
                // Only allow the session host (admin) to delete the session
                if (session.host === userID) {

                    // Disconnect all sockets associated with this session
                    io.of('/').in(sessionID).clients((error, socketIds) => {
                        if (error) throw error;
                        socketIds.forEach(socketId => io.sockets.sockets[socketId].disconnect(true));
                    });

                    // Delete session from session manager
                    SessionManager.deleteSession(sessionID);
                    socket.leave(sessionID); // Leave the socket room

                    // Broadcast message to other users in the session
                    socket.to(sessionID).emit('session deleted', { message: 'The session has been deleted by the host.' });

                    socket.emit('session deleted', sessionID);
                } else {
                    socket.emit('permissions error', 'Only the host can delete the session.');
                }
            } else {
                socket.emit('error', 'Invalid session ID');
            }
        });

        socket.on('disconnect', () => {
            console.log('Client disconnected');
        });
    });
}
