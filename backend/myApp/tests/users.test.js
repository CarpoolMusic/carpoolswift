const request = require('supertest');
const pool = require('../db');
const app = require('../app'); // Import your Express app 

describe('GET /users', () => {

  it('should get all users', async () => {
    const res = await request(app)
      .get('/users')
    console.log(res.body);
    expect(res.statusCode).toEqual(200)
    expect(Array.isArray(res.body)).toBe(true); // Check if the body is an array
    expect(res.body.length).toBeGreaterThan(0); // Check if the array is not empty
    expect(res.body[0]).toHaveProperty('id'); // Check if the first user object has an 'id' property
  })

});

describe('POST /users', () => {

    let createdUserId;

    it('should create a new user', async () => {
        const res = await request(app)
        .post('/users')
        .send({
            name: 'Test User',
            email: 'test@test.com',
            spotify_id: '123456'
        })
        expect(res.statusCode).toEqual(200)
        expect(res.body).toHaveProperty('id')

        createdUserId = res.body.id;
    })

    // Clean up: delete the created user
    afterAll(async () => {
        if (createdUserId) {
            try {
                await pool.query(
                  "DELETE FROM users WHERE id = $1",
                  [createdUserId]
                );
              } catch(err) {
                console.error(err.message);
              }
        }
    })
});