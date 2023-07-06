const httpServer = require('./app.js');

const port = 3000;
httpServer.listen(port, () => console.log(`Server running on port ${port}`));