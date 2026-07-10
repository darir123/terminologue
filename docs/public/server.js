const express = require('express');
const app = express();
const path = require('path');
const PORT = process.env.PORT || 8080;

// Serve static files from public folder
app.use(express.static(path.join(__dirname)));

// Redirect /terminologue to Terminologue on port 3000
app.get('/terminologue', (req, res) => {
    res.redirect('http://localhost:3000/');
});

app.get('/terminologue/*', (req, res) => {
    const subpath = req.params[0] || '';
    res.redirect('http://localhost:3000/' + subpath + (req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : ''));
});

app.listen(PORT, () => {
    console.log(`Personal website running at http://localhost:${PORT}/`);
    console.log(`Terminologue available at http://localhost:${PORT}/terminologue/`);
});
