const isDev = process.env.NODE_ENV !== 'production';
const AWS = require('aws-sdk');
const express = require('express');
const cors = require("cors");
const router = require('./router');
const app = express();
const port = 3000;
AWS.config.update({'region': 'us-east-1'});

app.use(cors());
app.use(express.json());
app.use(router);

app.listen(port, () => console.log(`Example app listening on port ${port}!`));


