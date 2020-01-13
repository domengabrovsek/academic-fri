'use strict';

const { move, compare, constructPath, getAdjMatrix } = require('./helpers');

module.exports = function BFS(graph, startNode, endNodes) {

  // transform graph to adjacent matrix
  let adjMatrix = getAdjMatrix(graph);
  console.log('\nAdjMatrix: ', adjMatrix);

  // flatten adjMatrix to get valid nodes list
  let validNodes = [].concat(...Object.keys(adjMatrix).map(key => adjMatrix[key]));
  console.log('\nValid nodes: ', validNodes);

  let visited = [];
  let parents = {};
  let queue = [];

  // start node
  parents[startNode] = null;
  visited[startNode] = true;
  queue.push(startNode);

  while(queue.length > 0) {

    // set current node 
    let currentNode = queue.shift();

    console.log('  Current node: ', currentNode);

    // if we found the final node
    if(endNodes.some(node => compare(node, currentNode))) {
      return constructPath(currentNode, parents);
    }
      
    // if node was not visited yet
    if(!visited[currentNode]) {

      visited[currentNode] = true;
      queue.push(currentNode);

      console.log(`  Adding node ${currentNode} to stack.`);
    }
      
    // check adjacent nodes (children)
    for(let direction of ['up', 'right', 'down', 'left']) {
      
      let adjacent = move(currentNode, direction);

      // if not visited yet and is valid node then add it to stack
      if(!visited[adjacent] && validNodes.some(node => compare(node, adjacent))) {
        parents[adjacent] = currentNode;
        console.log(`  Adding node ${adjacent} to stack.`);
        queue.push(adjacent);
      }
    }
  }
}
