const { Pool } = require('pg')

const pool = new Pool({
  user: 'nolb',
  host: 'localhost',
  database: 'musicqueuedb',
})

module.exports = pool;
