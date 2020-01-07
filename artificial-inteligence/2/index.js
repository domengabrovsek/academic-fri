'use strict';

const fs = require('fs');
const glob = require('glob');
const files = glob.sync(`${__dirname}/labyrinths/*.txt`);

let labyrinths = [];

files.forEach(file => {
    labyrinths.push(fs.readFileSync(file, 'utf8'));
})


console.log(labyrinths[0])
