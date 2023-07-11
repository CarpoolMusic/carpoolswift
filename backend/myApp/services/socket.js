const SessionManager = require('./sessionManager');
const Song = require('../models/song');

module.exports = function (io) {
    io.on('connection', (socket) => {
        console.log('clientConnected:', socket.id);

        // SOCKET EVENTS


        // SESSION CREATION AND MODIFICATION

        // When a user connects to the socket
        socket.emit('connected', { status: 'connected' });

        // When a user creates a session
        socket.on('create session', () => {
            const sessionId = SessionManager.createSession(socket.id);

            // Join the user to the session room
            socket.join(sessionId);

            // Send the session ID back to the client
            socket.emit('session created', sessionId);
        });

        // When a user wants to join a session
        socket.on('join session', (sessionId) => {
            const session = SessionManager.getSession(sessionId);

            if (session) {
                // Connect user to session
                socket.join(sessionId);
                // Add user to session object
                session.join(socket.id);
                socket.emit('session joined', sessionId);
            } else {
                socket.emit('error', 'Invalid session ID ( join session )');
            }
        });

        // When a user wants to leave a session (non-admin)
        socket.on('leave session', (sessionId) => {
            const session = SessionManager.getSession(sessionId);

            if (session) {
                if (session.isMember(socket.id) && !session.isHost(socket.id)) {
                    socket.emit('left session', sessionId); // Notify the user they've left the session

                    // Remove user from socket session
                    socket.leave(sessionId);
                    // Remove user from session object
                    session.remove(socket.id);

                    io.in(sessionId).emit('member left', socket.id); // Notify others in the room that a member has left
                } else {
                    socket.emit('permissions error', 'You are not a member of this session or you are the host of this session. If you are the host you must delete the session to leave or make another member host');
                }
            } else {
                socket.emit('error', 'Invalid session ID (leave session)');
            }
        });

        // When a user wants to delete a session
        socket.on('delete session', (sessionId) => {
            const session = SessionManager.getSession(sessionId);

            if (session) {
                // Only allow the session host (admin) to delete the session
                if (session.isHost(socket.id)) {

                    // Broadcast message to other users in the session
                    socket.to(sessionId).emit('session deleted', { message: 'The session has been deleted by the host.' });
                    socket.emit('session deleted', sessionId);

                    // Disconnect all sockets associated with this session
                    io.of('/').in(sessionId).allSockets()
                        .then((socketIds) => {
                            socketIds.forEach(socketId => io.sockets.sockets.get(socketId).disconnect(true));
                    })
                    .catch((error) => {
                        console.log('error');
                    });


                    // Delete session from session manager
                    SessionManager.deleteSession(sessionId);
                    socket.leave(sessionId); // Leave the socket room

                } else {
                    socket.emit('error', 'Only the host can delete the session.');
                }
            } else {
                socket.emit('error', 'Invalid session ID (delete session)');
            }
        });

        // QUEUE MODIFICATION

        socket.on('add song', ({ sessionId, songData }) => {
            const session = SessionManager.getSession(sessionId);
            if (!session) {
                socket.emit('error', 'Invalid session ID');
                return;
            }

            if (!session.isMember(socket.id)) {
                socket.emit('error', 'You are not a member of this session');
                return;
            }

            // Create the song object
            const song = new Song(songData.songID, songData.name, songData.artist, socket.id);

            // Add the song to the session queue
            session.addSong(song);

            // Broadcast the updated queue to all members in the session
            io.to(sessionId).emit('queue updated', session.queue);
        });

        socket.on('remove song', ({ sessionId, songID }) => {
            const session = SessionManager.getSession(sessionId);
            if (!session) {
              socket.emit('error', 'Invalid session ID');
              return;
            }
          
            if (!session.isMember(socket.id)) {
              socket.emit('error', 'You are not a member of this session');
              return;
            }
          
            const song = session.queue.find(song => song.songID === songID);
            if (!song) {
              socket.emit('error', 'Song not found in the session');
              return;
            }
          
            if(song.addedBy !== socket.id) {
              socket.emit('error', 'Only the user who added the song can remove it');
              return;
            }
          
            // Remove the song from the session queue
            session.removeSong(songID);
          
            // Broadcast the updated queue to all members in the session
            io.to(sessionId).emit('queue updated', session.queue);
          });

          socket.on('vote song', ({ sessionId, songID, vote }) => {
            const session = SessionManager.getSession(sessionId);
            if (!session) {
              socket.emit('error', 'Invalid session ID');
              return;
            }
          
            if (!session.isMember(socket.id)) {
              socket.emit('error', 'You are not a member of this session');
              return;
            }
          
            const song = session.queue.find(song => song.songID === songID);
            if (!song) {
              socket.emit('error', 'Song not found in the session');
              return;
            }
          
            // Add the vote to the song in the session queue
            session.voteOnSong(songID, vote);
            const votes = session.queue.find(song => song.songID === songID).votes; 

            // Broadcast the updated queue to all members in the session
            io.to(sessionId).emit('queue updated', session.queue);
          });

        socket.on('disconnect', () => {
            console.log('Client disconnected');
        });
    });
}
