const ioClient = require('socket.io-client');

let socket;
let otherSocket;

beforeEach(() => {

    // socket is the main socket we work with an otherScoket is used to listen to the broadcast events that socket creates
    socket = ioClient('http://localhost:3000');
    otherSocket = ioClient('http://localhost:3000');

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

    test('should create session', () => {

        new Promise((resolve) => {
            socket.on('session created', (sessionID) => {
                expect(sessionID).toBeDefined();
                resolve(sessionID);
            });
    
            socket.emit('create session');
        })
        .then((sessionID) => {
            done();
        })
        .catch((error) => {
            done(error);
        });
    
    });

    test('should join session', () => { 
        // Create the test session first
        new Promise((resolve) => {
            socket.on('session created', (sessionId) => {
                expect(sessionId).toBeDefined();
                resolve(sessionId);
            });
            socket.emit('create session');
        })
        .then((sessionId) => {
            // call from within the session created listener since we need to ensure the session has been created before we attempt to join
            return new Promise((resolve) => {
                otherSocket.on('session joined', (joinedSessionID) => {
                    expect(joinedSessionID).toEqual(sessionId);
                    resolve(joinedSessionID);
                }); 
                otherSocket.emit('join session', (sessionId));
            })
        })
        .then(() => {
            done();
        })
        .catch((error) => {
            done(error);
        });
    });

    test('should join and then leave session', () => {
        new Promise((resolve) => {
            socket.on('session created', (sessionId) => {
                expect(sessionId).toBeDefined();
                resolve(sessionId);
            });
    
            // Create the session
            socket.emit('create session');
        })
        .then((sessionId) => new Promise((resolve) => {
            // Other socket joins the session
            otherSocket.on('session joined', (joinedSessionID) => {
                expect(joinedSessionID).toEqual(sessionId);
                resolve(sessionId);
            });
    
            // Join other socket to the session
            otherSocket.emit('join session', sessionId);
        }))
        .then((sessionId) => new Promise((resolve) => {
            // Member left listener
            socket.on('member left', (socketId) => {
                expect(socketId).toEqual(otherSocket.id);
                resolve(sessionId);
            });
    
            // Leave the session as member listener
            otherSocket.on('left session', (leftSessionID) => {
                expect(leftSessionID).toEqual(sessionId); 
                resolve(sessionId);
            });
    
            // Leave the session as member
            otherSocket.emit('leave session', sessionId);
        }))
        .then((sessionId) => new Promise((resolve, reject) => {
            // Leave the session as host listener
            socket.on('permissions error', (message) => {
                const errMessage = 'You are not a member of this session or you are the host of this session. If you are the host you must delete the session to leave or make another member host'
                expect(message).toEqual(errMessage);
                resolve();
            });
    
            // Attempt to leave the session as host
            socket.emit('leave session', sessionId);
        }))
        .then(() => {
            done();
        })
        .catch((error) => {
            done(error);
        });
    });
     
    test('should delete a session', () => {
        new Promise((resolve, reject) => {
            socket.on('session created', (sessionId) => {
                resolve(sessionId);
            });
            
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Create the session
            socket.emit('create session');
        })
        .then((sessionId) => new Promise((resolve, reject) => {
            otherSocket.on('session joined', (joinedSessionId) => {
                expect(joinedSessionId).toEqual(sessionId);
                resolve(sessionId);
            });
    
            otherSocket.on('error', (error) => {
                reject(error);
            });
    
            // Other socket joins the session
            otherSocket.emit('join session', sessionId);
        }))
        .then((sessionId) => new Promise((resolve, reject) => {
            otherSocket.on('error', (message) => {
                const errMsg = 'Only the host can delete the session.';
                expect(message).toEqual(errMsg);
                resolve(sessionId);
            }); 
            // Other socket attempts to delete the session
            otherSocket.emit('delete session', (sessionId));
        }))
        .then((sessionId) => new Promise((resolve, reject) => {
            socket.on('session deleted', (deletedSessionId) => {
                expect(deletedSessionId).toBe(sessionId);
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                console.log(socket.id);
                reject(error);
            }); 

            // Socket deletes the session properly
            socket.emit('delete session', (sessionId));
        }))
        .then(() => {
            done();
        })
        .catch((error) => {
            done(error);
        });
    });
    
    test('should remove song from session queue', () => {
        const testSongData = {
            songID: '5678',
            name: 'Test Song',
            artist: 'Test Artist'
        };
    
        new Promise((resolve, reject) => {
            socket.on('session created', (sessionId) => {
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Create the session
            socket.emit('create session');
        })
        .then((sessionId) => new Promise((resolve, reject) => {
            socket.on('session joined', (joinedSessionId) => {
                expect(joinedSessionId).toEqual(sessionId);
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Join the session
            socket.emit('join session', sessionId);
        }))
        .then((sessionId) => new Promise((resolve, reject) => {
            socket.on('queue updated', (queue) => {
                expect(queue).toBeDefined();
                expect(queue).toHaveLength(1);
                expect(queue[0].songID).toEqual(testSongData.songID);
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Add a song once the session is joined
            socket.emit('add song', { sessionId: sessionId, songData: testSongData });
        }))
        .then((sessionId) => new Promise((resolve, reject) => {
            socket.on('queue updated', (queue) => {
                expect(queue).toBeDefined();
                expect(queue).toHaveLength(0);
                resolve();
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Remove the song after it was added
            socket.emit('remove song', { sessionId: sessionId, songID: testSongData.songID });
        }))
        .then(() => {
            done();
        })
        .catch((error) => {
            done(error);
        });
    });        

    test('should add a vote to a song', (done) => {
        const testSongData = {
            songID: 's1234',
            name: 'Test Song',
            artist: 'Test Artist',
            addedBy: socket.id,
        };
    
        new Promise((resolve, reject) => {
            socket.on('session created', (sessionId) => {
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Create the session
            socket.emit('create session');
        })
        .then((sessionId) => new Promise((resolve, reject) => {
            socket.on('session joined', (joinedSessionId) => {
                expect(joinedSessionId).toEqual(sessionId);
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Join the session
            socket.emit('join session', sessionId);
        }))
        .then((sessionId) => new Promise((resolve, reject) => {
            socket.on('queue updated', (queue) => {
                const songInQueue = queue.find(song => song.songID === testSongData.songID);
                expect(songInQueue).toBeDefined();
                resolve({sessionId, songInQueue});
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Add a song
            socket.emit('add song', { sessionId: sessionId, songData: testSongData });
        }))
        .then(({sessionId}) => new Promise((resolve, reject) => {
            socket.on('queue updated', (queueAfterVote) => {
                const songInQueueAfterVote = queueAfterVote.find(song => song.songID === testSongData.songID);
                expect(songInQueueAfterVote.votes).toEqual(1); // Assuming that song.votes was 0 initially
                resolve(sessionId);
            });
    
            socket.on('error', (error) => {
                reject(error);
            });
    
            // Vote the song
            socket.emit('vote song', { sessionId: sessionId, songID: testSongData.songID, vote: 1 });
        }))
        .then(() => {
            done();
        })
        .catch((error) => {
            done(error);
        });
    });     
});
