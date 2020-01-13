'use strict';

const { compare, constructPath, getAdjMatrix, getCost } = require('./helpers');

module.exports = function ASTAR(graph, startNode, endNodes) {

  // transform graph to adjacent matrix
  let adjMatrix = getAdjMatrix(graph);
  console.log('\nAdjMatrix: ', adjMatrix);

  // flatten adjMatrix to get valid nodes list
  let validNodes = [].concat(...Object.keys(adjMatrix).map(key => adjMatrix[key]));
  console.log('\nValid nodes: ', validNodes);

  // get costs for all nodes
  let hCost = validNodes.map(node => getCost(node, graph));
  console.log('hCost: ', hCost);

  let open = [];
  let parents = [];
  let gScore = [];
  let fScore = [];

  // set all to infinity for start
  for(let i = 0; i < graph.length; i++) {
    fScore[i] = Number.MAX_SAFE_INTEGER;
    gScore[i] = Number.MAX_SAFE_INTEGER;
  }

  gScore[startNode] = 0;
  fScore[startNode] = hCost[startNode];
  parents[startNode] = -1;

  // open starting node
  open.push();
  console.log('Opening node: ', startNode);

  while(open.length > 0) {
    let minVal = Number.MAX_SAFE_INTEGER;
    let minPos = 0;
    let currentNode = 0;

    for(let i = 0; i < open.length; i++) {
      let node = open[i];
      if(fScore[node] < minVal) {
        minVal = fScore[node];
        minPos = i;
        currentNode = node;
      }
    }

    let index = open.indexOf(minPos);

    if(index >= -1) {
      open.splice(index, 1);
    }
    
    closed[currentNode] = true;
    console.log('Closing node: ', currentNode);

    // if we found the final node
    if(endNodes.some(node => compare(node, currentNode))) {
      return constructPath(currentNode, parents);
    }

    for(let nextNode = 0; nextNode < graph[currentNode].length; nextNode++) {
      if(graph[currentNode][nextNode] > 0 && !closed[nextNode]) {
        if(!open.some(node => compare(node, nextNode))) {
          console.log('Opening node: ', nextNode);
        }

        open.push(nextNode);

        let distance = gScore[currentNode] + graph[currentNode][nextNode];

        if(distance < gScore[nextNode]) {
          parents[nextNode] = currentNode;
          gScore[nextNode] = distance;
          fScore[nextNode] = gScore[nextNode] + hCost[nextNode];
          console.log('Updating node: ', nextNode);
        }
      }
    }
  }
};