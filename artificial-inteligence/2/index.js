'use strict';

const DFS = require('./src/DFS');
const BFS = require('./src/BFS');
const { transform, findStartEnd, getAdjMatrix, getPathLength } = require('./src/helpers');
const { getLabyrinths } = require('./src/fileHelpers');

// TODO add more algorithms 
const algorithms = ['dfs', 'bfs', 'astar'];

// read from user input and execute according to input
console.clear();
console.log('Please enter algorithm and labyrinth number: ');

let stdin = process.openStdin();

stdin.addListener("data", input => {

    input = input.toString().trim().split(' ');

    const algorithm = input[0];
    const labyrinth = input[1];

    console.clear();
    console.log('Algorythm:', algorithm);
    console.log('Labyrinth:', labyrinth);

    // validate algorithm input
    if(!algorithms.includes(algorithm)) {
        return console.log('Wrong algorithm selected! Please use one of', algorithms, '.');
    }

    // validate labyrinth input
    if(labyrinth === undefined || labyrinth < 0 || labyrinth > 15) {
        return console.log('Wrong labyrinth number selected! Please use one of [0-15].')
    }

    // get all labyrinth definitions
    const labyrinths = getLabyrinths();

    // transform initial labyrinth structure to array
    let graph = transform(labyrinths[labyrinth]);

    // find where to start/end search
    let { startNode, endNodes } = findStartEnd(graph);

    // transform graph to adjacent matrix
    let adjMatrix = getAdjMatrix(graph);

    // flatten adjMatrix to get valid nodes list
    let validNodes = [].concat(...Object.keys(adjMatrix).map(key => adjMatrix[key]));

    // path will be returned by the search algorithm
    let path;

    console.log('Graph: ', graph);
    console.log(`\nStart node: ${startNode}`);
    console.log(`End nodes: ${endNodes}`);
    console.log('\nAdjMatrix: ', adjMatrix);

    console.log(`\nStarting search: `);

    // have to decide which algorithm to run on which graph (labyrinth)
    switch(algorithm) {
        case 'dfs': {
            path = DFS(validNodes, startNode, endNodes);
            break;
        }
        case 'bfs': {
            path = BFS(validNodes, startNode, endNodes);
            break;
        }
        case 'astar': {
            // TODO
            break;
        }
    }

    console.log('Path length: ', getPathLength(path, graph));
    console.log('Found end node using path: ', path);
});