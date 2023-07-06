const axios = require('axios');
const express = require('express');
const router = express.Router();

const getAuthHeader = () => {
    return 'Basic ' + Buffer.from(SPOTIFY_CLIENT_ID + ':' + SPOTIFY_CLIENT_SECRET).toString('base64');
}

router.post('/api/token', async (req, res) => {
    try {
        const response = await axios.post('https://accounts.spotify.com/api/token', null, {
            params: {
                code: req.body.code,
                redirect_uri: 'spotify-ios-quick-start://spotify-login-callback',
                grant_type: 'authorization_code'
            },
            headers: {
                'Authorization': getAuthHeader()
            }
        });
        
        res.json({
            access_token: response.data.access_token,
            refresh_token: response.data.refresh_token
        });
    } catch (err) {
        console.error(err);
        res.status(400).json({ error: 'Failed to exchange code for token' });
    }
});

router.post('/api/refresh_token', async (req, res) => {
    try {
        const response = await axios.post('https://accounts.spotify.com/api/token', null, {
            params: {
                grant_type: 'refresh_token',
                refresh_token: req.body.refresh_token
            },
            headers: {
                'Authorization': getAuthHeader()
            }
        });
        
        res.json({
            access_token: response.data.access_token,
        });
    } catch (err) {
        console.error(err);
        res.status(400).json({ error: 'Failed to refresh token' });
    }
});

module.exports = router;