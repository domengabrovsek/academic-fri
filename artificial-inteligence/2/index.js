'use strict';

const DFS = require('./src/DFS');
const BFS = require('./src/BFS');
const ASTAR = require('./src/ASTAR');
const IDDFS = require('./src/IDDFS');

const { transform, findStartEnd, getPathPrice, getDistance } = require('./src/helpers');
const { getLabyrinths } = require('./src/fileHelpers');

// TODO add more algorithms 
const algorithms = ['dfs', 'bfs', 'astar', 'iddfs'];

// read from user input and execute according to input
console.clear();
console.log('Please enter algorithm and labyrinth number: ');

let stdin = process.openStdin();

stdin.addListener("data", input => {

    input = input.toString().trim().split(' ');

    const algorithm = input[0];
    const labyrinth = input[1];

    console.clear();
    console.log('Algorithm:', algorithm);
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

    // path will be returned by the search algorithm
    let path;

    console.log('Graph: ', graph);
    console.log(`\nStart node: ${startNode}`);
    console.log(`End nodes: ${endNodes}`);
    console.log(`\nStarting search: `);

    // have to decide which algorithm to run on which graph (labyrinth)
    switch(algorithm) {
        // depth first search
        case 'dfs': {
            path = DFS(graph, startNode, endNodes);
            break;
        }
        // breadth first search
        case 'bfs': {
            path = BFS(graph, startNode, endNodes);
            break;
        }
        // a* search
        case 'astar': {
            path = ASTAR(graph, startNode, endNodes)
            break;
        }
        // iterative deepening search
        case 'iddfs': {
            path = IDDFS(graph, startNode, endNodes);
            break;
        }
        // iterative deepening a* search
        case 'idas': {
            // TODO
            break;
        }
    }
    console.log('Max graph depth: ', graph.length);
    console.log('Path price: ', getPathPrice(path, graph));
    console.log('Path length:', getDistance(path[0], path[path.length - 1]));
    console.log('Found end node using path: ', path);
});