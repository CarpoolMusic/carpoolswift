const pool = require('../db');

describe('Database Connection', () => {
  it('should connect to the database', done => {
    pool.query('SELECT 1', (err, res) => {
      expect(err).toBeFalsy();
      done();
    });
  });
});

afterAll(() => {
    pool.end();
  });