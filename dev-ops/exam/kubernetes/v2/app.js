'use strict';

const express = require('express');
const os = require('os');

const app = express();
const PORT = 8080;
const HOST = '0.0.0.0';

let firstTime = true;

app.get('/', async(req, res) => {
  if(firstTime) {
    await new Promise(r => setTimeout(r, 2000));
    firstTime = false;
  }
  
  res.send(`hello from 'Domen' v2 on host ${os.hostname}`);
});

app.get('/live', (req, res) => {
  if(firstTime) {
    await new Promise(r => setTimeout(r, 2000));
    firstTime = false;
  }
  res.send('OK');
});

app.get('/ready', (req, res) => {
  if(firstTime) {
    await new Promise(r => setTimeout(r, 2000));
    firstTime = false;
  }
  res.send('Yes');
});

app.listen(PORT, HOST);