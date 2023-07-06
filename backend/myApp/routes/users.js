const express = require('express');
const router = express.Router();
const pool = require('../db'); // assuming you stored the connection pool in db.js

router.get('/', async (req, res) => {
  try {
    const users = await pool.query("SELECT * FROM users");
    res.json(users.rows);
  } catch(err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

router.post('/', async (req, res) => {
  const { name, email, spotify_id } = req.body;
  try {
    const newUser = await pool.query(
      "INSERT INTO users (name, email, spotify_id) VALUES ($1, $2, $3) RETURNING *",
      [name, email, spotify_id]
    );
    res.json(newUser.rows[0]);
  } catch(err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

router.put('/:id', async (req, res) => {
  const { name, email } = req.body;
  const { id } = req.params;
  try {
    const updateUser = await pool.query(
      "UPDATE users SET name = $1, email = $2 WHERE id = $3 RETURNING *",
      [name, email, id]
    );
    res.json(updateUser.rows[0]);
  } catch(err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query(
      "DELETE FROM users WHERE id = $1",
      [id]
    );
    res.json({ message: "User was deleted successfully." });
  } catch(err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});


module.exports = router;
