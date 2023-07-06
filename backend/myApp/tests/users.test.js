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

describe('UPDATE users/:id', () => {
    let createdUserId;
  
    // Before any tests run, create a user
    beforeAll(async () => {
      const res = await request(app)
        .post('/users')
        .send({
          name: 'Test User',
          email: 'test@test.com',
          spotify_id: '123456'
        })
  
      createdUserId = res.body.id;
    })
  
    // After all tests have run, delete the user
    afterAll(async () => {
      if (createdUserId) {
        await request(app)
          .delete(`/users/${createdUserId}`)
      }
    })
  
    it('should update an existing user', async () => {
      const res = await request(app)
        .put(`/users/${createdUserId}`)
        .send({
          name: 'Updated Name',
          email: 'updated@test.com'
        })
      expect(res.statusCode).toEqual(200)
      expect(res.body).toHaveProperty('id')
      expect(res.body.name).toBe('Updated Name')
      expect(res.body.email).toBe('updated@test.com')
    })
  });

  describe('DELETE existing user', () => {
    let createdUserId;
  
    // Before any tests run, create a user
    beforeEach(async () => {
      const res = await request(app)
        .post('/users')
        .send({
          name: 'Test User',
          email: 'test@test.com',
          spotify_id: '123456'
        })
      createdUserId = res.body.id;
    })
  
    it('should delete an existing user', async () => {
      const res = await request(app)
        .delete(`/users/${createdUserId}`)
      expect(res.statusCode).toEqual(200)
      expect(res.body).toEqual({ message: "User was deleted successfully." })
    })
  });
