'use strict';

const DFS = require('./src/DFS');
const BFS = require('./src/BFS');
const ASTAR = require('./src/ASTAR');
const IDDFS = require('./src/IDDFS');

const { performance } = require('perf_hooks');
const { transform, findStartEnd, getPathPrice, getAdjMatrix } = require('./src/helpers');
const { getLabyrinths, files } = require('./src/fileHelpers');

// TODO add more algorithms 
const algorithms = ['dfs', 'bfs', 'astar', 'iddfs', 'idastar'];

let stdin = process.openStdin();

// read from user input and execute according to input
console.clear();
console.log('files: ', files);
console.log('Algorithms: ', algorithms);
console.log('Labyrinths: [0-15]');
console.log('Please enter algorithm and labyrinth number e.g. "dfs 1": ');

stdin.addListener("data", input => {

    input = input.toString().trim().split(' ');

    const algorithm = input[0];
    const labyrinth = input[1];

    console.clear();
    console.log('-------------------------------------------------------');
    console.log('\nAlgorithm:', algorithm);
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
    // console.log('\nAdjMatrix: ', adjMatrix);

    // flatten adjMatrix to get valid nodes list
    let validNodes = [].concat(...Object.keys(adjMatrix).map(key => adjMatrix[key]));
    // console.log('\nValid nodes: ', validNodes);

    // console.log('\nGraph: ', graph);
    console.log(`Start node: [${startNode}]`);
    console.log(`End nodes: ${endNodes.map(node => `[${node}]`)}`);
    console.log(`\nStarting search: `);

    let t0 = performance.now();
    let result, path, steps;

    // have to decide which algorithm to run on which graph (labyrinth)
    switch(algorithm) {
        // depth first search
        case 'dfs': {
            result = DFS(validNodes, startNode, endNodes);
            steps = result.steps;
            path = result.path;
            break;
        }
        // breadth first search
        case 'bfs': {
            result = BFS(validNodes, startNode, endNodes);
            steps = result.steps;
            path = result.path;
            break;
        }
        // a* search
        case 'astar': {
            result = ASTAR(validNodes, startNode, endNodes)
            steps = result.steps;
            path = result.path;
            break;
        }
        // iterative deepening search
        case 'iddfs': {
            result = IDDFS(validNodes, startNode, endNodes);
            steps = result.steps;
            path = result.path;
            break;
        }
        // iterative deepening a* search
        case 'idas': {
            // TODO
            break;
        }
    }

    let t1 = performance.now();

    console.log(`Time spent searching: ${(t1 - t0)}ms`);
    console.log(`Steps made: ${steps}`);
    console.log('Max graph depth: ', graph.length);
    console.log('Path price: ', getPathPrice(path, graph));
    console.log('Path length:', path.length - 1); // without starting node
    console.log('Found end node using path: ', path);
});
