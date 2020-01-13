'use strict';

const { move, compare, constructPath } = require('./helpers');

module.exports = function BFS(graph, startNode, endNodes) {

  let visited = [];
  let parents = {};
  let queue = [];
  let steps = 0;

  // start node
  parents[startNode] = null;
  visited[startNode] = true;
  queue.push(startNode);
  steps++;
  console.log(`  Adding node ${startNode} to queue.`);

  // while we have elements in queue we iterate
  while(queue.length > 0) {

    // set current node 
    let currentNode = queue.shift();
    console.log(`  Removing node ${currentNode} from queue.`);

    // if we found the final node
    if(endNodes.some(node => compare(node, currentNode))) {
      return { path: constructPath(currentNode, parents), steps };
    }
      
    // check adjacent nodes (children)
    for(let direction of ['up', 'right', 'down', 'left']) {
      
      let adjacent = move(currentNode, direction);

      // if not visited yet and is valid node then add it to stack
      if(!visited[adjacent] && graph.some(node => compare(node, adjacent))) {
        visited[adjacent] = true;
        parents[adjacent] = currentNode;
        queue.push(adjacent);
        steps++;
        console.log(`  Adding node ${adjacent} to queue.`);
      }
    }
  }
}
