const ioClient = require('socket.io-client');

let socket;
let otherSocket;

beforeEach(() => {
    // socket is the main socket we work with an otherScoket is used to listen to the broadcast events that socket creates
    socket = ioClient('http://localhost:3000');
    otherSocket = ioClient('http://localhost:3000');

    // Set up error handling listener
    socket.on('error', (error) => {
        throw new Error(error);
    });
    otherSocket.on('error', (error) => {
        throw new Error(error)
    });

    return Promise.all([
        new Promise((resolve) => socket.on('connected', resolve)),
        new Promise((resolve) => otherSocket.on('connected', resolve)),
      ]);

});

afterEach(() => {
    if (socket.connected) {
        socket.disconnect();
    }
    if (otherSocket.connected) {
        otherSocket.disconnect();
    }
});

describe('socket.io events', () => {
    test('should create session', (done) => {

    socket.on('session created', (sessionID) => {
        expect(sessionID).toBeDefined();
        done();
    });

    socket.emit('create session', '1234');
    });

    test('should join session', (done) => {

        const testUserID = '1234';
        let testSessionID;

        // Create the test session first
        socket.on('session created', (sessionID) => {
            expect(sessionID).toBeDefined();
            testSessionID = sessionID;
            // call from within the session created listener since we need to ensure the session has been created before we attempt to join
            otherSocket.emit('join session', testSessionID);
            done();
        });
        socket.emit('create session', testUserID);

        // Join the test session that we created
        // Note that creating the sesson implicitly joins the session so we will use other socket to test the joining functionality
        otherSocket.on('session joined', (joinedSessionID) => {
        expect(joinedSessionID).toEqual(testSessionID);
        done();
        });
    });

    test('should join and then leave session', (done) => {

        let testSessionId;
        const hostId = '1234';
        const memberId = '4321';

        // Session created listener
        socket.on('session created', (sessionID) => {
            expect(sessionID).toBeDefined();
            testSessionId = sessionID;
            done();

            // Join other socket to the session
            // Note that inside the listener for session crated since we need to wait for the session to be created
            otherSocket.emit('join session', testSessionId);
        });
        // Create the session
        socket.emit('create session', hostId);

        // Session joined listener for other Socket
        otherSocket.on('session joined', (joinedSessionID) => {
            expect(joinedSessionID).toEqual(testSessionId);
            done();
            // Leave the session as member
            // Calling from here to ensure that the session has been created and otherSocket is part of that session
            otherSocket.emit('leave session', testSessionId);
        });

        // Leave the session as member listener
        otherSocket.on('left session', (leftSessionID) => {
        expect(leftSessionID).toEqual(testSessionId);
        done();
        });

        // Member left listener
        socket.on('member left', (socketId) => {
            expect(socketId.toEqual(memberId));
            done();
        });

        // Leave the session as host listener
        socket.on('permissions error', (message) => {
            const errMessage = 'You are not a member of this session or you are the host of this session. If you are the host you must delete the session to leave or make another member host'
            expect(message).toEqual(errMessage);
            done();
        });


        // Leave the session as host
        socket.emit('leave session', testSessionId);

    });

    test('should delete a session', (done) => {

        let testSessionId;
        let hostId = '1234';
        let memberId = '4321';

        socket.on('session created', (sessionID) => {
            testSessionId = sessionID;
            done();
            otherSocket.emit('join session', testSessionId);
        });
        socket.emit('create session', hostId);

        otherSocket.on('session joined', (joinedSessionID) => {
            expect(joinedSessionID).toEqual(testSessionId);
            done();
            otherSocket.emit('delete session', { userID: memberId, sessionID: testSessionId });
        });

        socket.on('session deleted', (deletedSessionID) => {
            expect(deletedSessionID).toBe(testSessionId);
            done();
            // ensure that the member client is disconnected
            otherSocket.on('disconnect', () => {
                done();
            });
        });
        
        otherSocket.on('permissions error', (message) => {
            const errMsg = 'Only the host can delete the session.';
            expect(message).toEqual(errMsg);
            done();
            // now delete the session proplery
            socket.emit('delete session', { userID: hostId, sessionID: testSessionId });
        });

        });

    test('should add song to session queue', (done) => {
        const testUserID = '1234';
        let testSessionID;

        // Define song data
        const testSongData = {
            songID: '5678',
            name: 'Test Song',
            artist: 'Test Artist'
        };

        // Create the test session first
        socket.on('session created', (sessionID) => {
            expect(sessionID).toBeDefined();
            testSessionID = sessionID;
            done();

            // Other socket joins the session
            otherSocket.emit('join session', testSessionID);
        });
        socket.emit('create session', testUserID);

        // Other socket joins the test session
        otherSocket.on('session joined', (joinedSessionID) => {
            expect(joinedSessionID).toEqual(testSessionID);
            done();

            // Other socket adds a song to the session queue
            otherSocket.emit('add song', { sessionId: testSessionID, userId: testUserID, songData: testSongData });
        });

        // Check that the song was successfully added to the session queue and broadcast
        otherSocket.on('queue updated', (queue) => {
            expect(queue).toBeDefined();
            expect(queue).toHaveLength(1);
            expect(queue[0].songID).toEqual(testSongData.songID);
            expect(queue[0].name).toEqual(testSongData.name);
            expect(queue[0].artist).toEqual(testSongData.artist);
            done();
        });
        socket.on('queue updated', (queue) => {
            expect(queue).toBeDefined();
            expect(queue).toHaveLength(1);
            expect(queue[0].songID).toEqual(testSongData.songID);
            expect(queue[0].name).toEqual(testSongData.name);
            expect(queue[0].artist).toEqual(testSongData.artist);
            done();
        });


    });

    test('should remove song from session queue', (done) => {
        const testUserID = '1234';
        let testSessionID;
    
        // Define song data
        const testSongData = {
            songID: '5678',
            name: 'Test Song',
            artist: 'Test Artist'
        };
    
        // Create the test session first
        socket.on('session created', (sessionID) => {
            expect(sessionID).toBeDefined();
            testSessionID = sessionID;
            done();
    
            // Join the session
            socket.emit('join session', testSessionID);
        });
        socket.emit('create session', testUserID);

        // Add a song once the session is joined
        socket.on('session joined', (sessionId) => {
            socket.emit('add song', { sessionId: testSessionID, userId: testUserID, songData: testSongData });
            done();
        });
    
        // Remove the song after it was added
        socket.on('queue updated', (queue) => {
            expect(queue).toBeDefined();
            expect(queue).toHaveLength(1);
            expect(queue[0].songID).toEqual(testSongData.songID);
    
            // Now, remove the song
            socket.emit('remove song', { sessionId: testSessionID, userId: testUserID, songID: testSongData.songID });
            done();
        });
    
        // Check that the song was successfully removed from the session queue
        socket.on('queue updated', (queue) => {
            expect(queue).toBeDefined();
            expect(queue).toHaveLength(0);
            done();
        });
    });

    test('should add a vote to a song', (done) => {
        const testUserID = '1234';
        const testSongData = {
          songID: 's1234',
          name: 'Test Song',
          artist: 'Test Artist',
          addedBy: testUserID,
        };
        let testSessionID;
      
        socket.on('session created', (sessionID) => {
          expect(sessionID).toBeDefined();
          testSessionID = sessionID;
       
          socket.on('session joined', (joinedSessionID) => {
            expect(joinedSessionID).toEqual(testSessionID);
       
            socket.on('queue updated', (queue) => {
              const songInQueue = queue.find(song => song.songID === testSongData.songID);
              expect(songInQueue).toBeDefined();
       
              socket.on('queue updated', (queueAfterVote) => {
                const songInQueueAfterVote = queueAfterVote.find(song => song.songID === testSongData.songID);
                expect(songInQueueAfterVote.votes).toEqual(1); // Assuming that song.votes was 0 initially
      
                done();
              });
                // Vote the song
                socket.emit('vote song', { sessionId: testSessionID, userId: testUserID, songID: testSongData.songID, vote: 1 });
            });
                socket.emit('add song', { sessionId: testSessionID, userId: testUserID, songData: testSongData });
          });
            socket.emit('join session', testSessionID);
        });  
        socket.emit('create session', testUserID);
      });



});
