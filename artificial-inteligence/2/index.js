'use strict';

const fs = require('fs');
const glob = require('glob');
const files = glob.sync(`${__dirname}/labyrinths/*.txt`);
const DFS = require('./DFS');
const { transform, findStartEnd, getAdjMatrix, getParent } = require('./helpers');

let labyrinths = [];

files.forEach(file => {
    labyrinths.push(fs.readFileSync(file, 'utf8'));
})

let graph = transform(labyrinths[0]);
let adjMatrix = getAdjMatrix(graph);
let { startNode, endNodes } = findStartEnd(graph);

console.log(graph);
console.log(`\nStart: ${startNode}`);
console.log(`End: `);
endNodes.forEach(endNode => console.log(`  ${endNode}`));

console.log('\ngraph: ', graph);
console.log('\nadjMatrix: ', adjMatrix);

DFS(adjMatrix, startNode, endNodes);
// console.log(getParent(adjMatrix, [2, 1]));





// DFS(graph, startNode, endNodes);
