'use strict';

const glob = require('glob');
const fs = require('fs');
const path = require('path');
const files = glob.sync(`${path.join(__dirname, '../', 'labyrinths')}/*.txt`);

function getLabyrinths() {
  return files.map(file => fs.readFileSync(file, 'utf8'));
}

module.exports = {
  getLabyrinths
};