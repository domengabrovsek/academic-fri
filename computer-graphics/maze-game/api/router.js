'use strict';

const express = require('express');
const router = new express.Router();
const AWS = require('aws-sdk');
const { uuid } = require('uuidv4');
const config = require('./config.js');
AWS.config.update({'region': 'us-east-1'});

// Add a entry
router.post('/statistic', (req, res, next) => {
    let data = req.body;

    if (Object.keys(data).length > 0) {
        const docClient = new AWS.DynamoDB.DocumentClient();
        const id = uuid();
        data.id = id;
        const params = {
            TableName: config.aws_table_name,
            Item: data
        };
        docClient.put(params, function (err, data) {
            if (err) {
                console.log(err);
                res.send({
                    success: false,
                    message: 'Error: Server error'
                });
            } else {
                res.send({
                    success: true,
                    message: 'Added entry',
                    id: id
                });
            }
        });
    }
});

/* get statictics data grouped by user */
router.get("/statistic", (req, res) => {
    const docClient = new AWS.DynamoDB.DocumentClient();

    const params = {
        TableName: config.aws_table_name
    };

    docClient.scan(params, function (err, data) {
        if (err) {
            console.log(err);
            res.send({
                success: false,
                message: 'Error: Server error'
            });
        } else {
            const { Items } = data;
            
            // sort items by time
            Items.sort((a,b) => a.time - b.time);
            res.send(Items);
        }
    });
});

module.exports = router;