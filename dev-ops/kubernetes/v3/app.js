'use strict';

console.log('Hello world!');

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', async (req, res) => {
  console.log('Processing...');
  await new Promise(r => setTimeout(r, 1000));
  res.send('Hello World - v3');
});

app.get('/live', (req, res) => {
  res.send('OK');
});

app.get('/ready', (req, res) => {
  res.send('Yes');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);