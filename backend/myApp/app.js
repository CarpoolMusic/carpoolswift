const db = require('./db');

require('dotenv').config();
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const path = require('path');
const cookieParser = require('cookie-parser');
var logger = require('morgan');

const SessionManager = require('./services/sessionManager');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var spotifyRouter = require('./routes/spotify');

// Create an express.js app
const app = express();

// Create a http server using the Express app
const httpServer = http.createServer(app);

// Create a socket.IO instance attached to the http server
const io = socketIo(httpServer);


const SPOTIFY_CLIENT_ID = process.env.SPOTIFY_CLIENT_ID;
const SPOTIFY_CLIENT_SECRET = process.env.SPOTIFY_CLIENT_SECRET;

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(cors());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/spotify', spotifyRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(new Error('Not Found'));
});

// Set up a connection event to listen for a new connection
io.on('connection', (socket) => {

  console.log(`New client connected: ${socket.id}`);
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

  // Example: a custom event that sends a message to the client
  socket.on('custom event', data => {
    console.log(data);
  });

  // Disconnect event
  socket.on('disconnect', () => {
    console.log('Client disconnected');
  })
})

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = httpServer;
