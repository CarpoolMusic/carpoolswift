const ioClient = require('socket.io-client');
const SessionManager = require('../services/sessionManager');

let socket;

beforeEach((done) => {
  socket = ioClient('http://localhost:3000');
  socket.on('connected', () => {
    done();
  });
});

afterEach(() => {
  if (socket.connected) {
    socket.disconnect();
  }
});

describe('socket.io events', () => {
  test('should create session', (done) => {
    socket.emit('create session', '1234');

    socket.on('session created', (sessionID) => {
      expect(sessionID).toBeDefined();
      done();
    });
  });

  test('should join session', (done) => {
    const sessionID = SessionManager.createSession('1234');
    socket.emit('join session', sessionID);

    socket.on('session joined', (joinedSessionID) => {
      expect(joinedSessionID).toEqual(sessionID);
      done();
    });

    socket.on('error', (error) => {
      throw new Error('Test failed');
    });
  });
});
