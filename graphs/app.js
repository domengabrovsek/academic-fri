'use strict';

console.clear();

const { allTowns, getRandomNumber } = require('./helpers');


let graph = {
    V: 0,
    E: 0,
    edges: [],
    distances: [],
    hasNegativeCycle: false
};

let nodesSet = new Set();

function fillGraphMyExample(){
    const example = ['S', 'T', 'X', 'Y', 'Z'];

    // add all nodes 
    example.forEach(node => addNode(node));

    // add all edges
    addEdge('Z', 'S', 2);
    addEdge('S', 'T', 6);
    addEdge('X', 'T', -2);
    addEdge('T', 'X', 5);
    addEdge('Y', 'X', -3);
    addEdge('Z', 'X', 7);
    addEdge('S', 'Y', 7);
    addEdge('T', 'Y', 8);
    addEdge('Y', 'Z', 9);
    addEdge('T', 'Z', -4);
}

function fillGraphUndirected(npoints, ncrosslinks){
    for(let i = 0; i < npoints; i++){
        addNode(allTowns[i]);
    }

    let t = getNodes();

    console.table(t);

    let a, b, w;

    // console.log('First loop');
    for(let i = 1; i < t.length; i++){
        a = getRandomNumber(i);
        w = getRandomNumber(10) + 1;

        // console.log(`a: ${t[i]}, b: ${t[a]}, w: ${w}`);
        addEdge(t[i], t[a], w);

        // console.log(`a: ${t[a]}, b: ${t[i]}, w: ${w}`);
        addEdge(t[a], t[i], w);
    }

    // console.log('\nSecond loop');
    for(let i = 0; npoints > 1 && i < ncrosslinks; i++){
        a = getRandomNumber(npoints - 1) + 1;
        b = getRandomNumber(a);
        w = getRandomNumber(10) + 1;

        // console.log(`a(${a}): ${t[a]}, b(${b}): ${t[b]}, w: ${w}`);
        addEdge(t[a], t[b], w);

        // console.log(`a: ${t[b]}, b: ${t[a]}, w: ${w}`);
        addEdge(t[b], t[a], w);
    }

}


// test

// fillGraphMyExample();

fillGraphUndirected(5,3);

computeShortestPaths(getNodes()[0]);

console.log('GRAPH:');
console.dir(graph);

const start = 'bolergrad'; 
const end = 'pasjigrad';

const { shortestPath, shortestDistance } = getShortestPath(start, end);
console.log(`Shortest path from '${start}' to '${end}' is '${shortestPath}' (${shortestDistance})`);


/* ------------------------------------------------------------ */

function addNode(s) {

    if(!nodesSet.has(s)){
        nodesSet.add(s);
        graph.V += 1;
        return true;
    }

    return false;
}

function getNodes() {
    return Array.from(nodesSet);
}

// string a, string b, int w
function addEdge(a, b, w){
    graph.edges.push({
        source: a,
        destination: b,
        weight: w
    });

    graph.E += 1;
}

// string start
function computeShortestPaths(start) {
    // initialize 
    getNodes().forEach(node => {
        graph.distances[node] = {
            cost: Number.MAX_SAFE_INTEGER,
            source: "",
            destination: ""
        };
    });

    // set start to 0
    graph.distances[start] = {
        cost: 0,
        source: start,
        destination: start
    };

    // Bellman-Ford
    for(let i = 0; i < graph.V; ++i){
        for(let j = 0; j < graph.E; ++j){
            let u = graph.edges[j].source;
            let v = graph.edges[j].destination;
            let weight = graph.edges[j].weight;

            if(graph.distances[u].cost != Number.MAX_SAFE_INTEGER && (graph.distances[u].cost + weight) < graph.distances[v].cost){
                graph.distances[v] = {
                    cost: graph.distances[u].cost + weight,
                    source: u,
                    destination: v
                }
            }
        }
    }

    // check for negative cycle
    for(let i = 0; i < graph.E; ++i){
        let u = graph.edges[i].source;
        let v = graph.edges[i].destination;
        let weight = graph.edges[i].weight;

        if(graph.distances[u].cost != Number.MAX_SAFE_INTEGER && (graph.distances[u].cost + weight) < graph.distances[v].cost){
            graph.hasNegativeCycle = true;
            return;
        }
    }
}

function getShortestPath(start, dest) {

    if(graph.hasNegativeCycle){
        return { shortestPath: "NEGATIVE CYCLE!"}
    }

    let shortestPath = { 
        path: [],
        cost: 0
    };

    let source = graph.distances[dest].source;
    let destination = dest;

    shortestPath.path.push(dest);
    shortestPath.cost += graph.edges.find(edge => edge.source === source && edge.destination === destination).weight;

    do {
        // console.log(`source: ${source} , destination: ${destination}`);
        destination = source;
        source = graph.distances[destination].source;

        shortestPath.path.unshift(destination);

        const result = graph.edges.find(edge => edge.source === source && edge.destination === destination);
        if(result){
            shortestPath.cost += result.weight;
        }
    }
    while(start != destination);

    return { shortestPath: shortestPath.path, shortestDistance: shortestPath.cost }
}