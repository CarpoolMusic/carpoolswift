const db = require('./db');

require('dotenv').config();
const express = require('express');
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
const http = require('http');
const socketIo = require('socket.io');
const httpServer = http.createServer(app);
// Create a socket.IO instance attached to the http server
const io = socketIo(httpServer);

require('./services/socket')(io);



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
