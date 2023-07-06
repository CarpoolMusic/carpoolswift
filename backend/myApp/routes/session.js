const express = require('express');
const router = express.Router();

router.post('/', async (req, res) => {
  // Get the user ID from the request
  const userId = req.body.userId;

  // Create a new session
  const newSession = await Session.create({ userId });

  // Emit a message to the WebSocket to create a new "room"
  io.of('/sessions').emit('new-session', { sessionId: newSession.id });

  // Return the new session
  res.json(newSession);
});

module.exports = router;