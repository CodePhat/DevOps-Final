const express = require('express');
const os = require('os');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send(`
        <h1>Production-Grade CI/CD System</h1>
        <p>Deployment Tier: <b>Docker Swarm</b></p>
        <p>Server Hostname: <b>${os.hostname()}</b></p>
        <p>Status: <span style="color: red;">Offline</span></p>
        <p>Version: 1.0.0</p>
    `);
});

app.listen(port, () => {
    console.log(`App running at http://localhost:${port}`);
}); 