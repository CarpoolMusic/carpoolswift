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

});
