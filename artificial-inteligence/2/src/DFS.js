'use strict';

const { move, compare } = require('./helpers');

module.exports = function DFS(graph, startNode, endNodes) {

  let visited = [];
  let parents = {};

  // flatten graph to valid nodes list
  let validNodes = [].concat(...Object.keys(graph).map(key => graph[key]));

  let stack = [];

  // start node
  parents[startNode] = [-1, -1];
  visited[startNode] = true;

  stack.push(startNode);

  while(stack.length > 0) {

    // set current node 
    let currentNode = stack.pop();

    console.log('  Current node: ', currentNode);

    // if we found the final node
    if(endNodes.some(node => compare(node, currentNode))) {
      let path = Object.keys(parents);

      // add final node to path
      path.push(currentNode.toString());

      return path;
    }
      
    // if node was not visited yet
    if(!visited[currentNode]) {

      visited[currentNode] = true;
      parents[currentNode] = currentNode;
      stack.push(currentNode);

      console.log(`  Adding node ${currentNode} to stack.`);
    }
      
    // check adjacent nodes (children)
    for(let direction of ['up', 'right', 'down', 'left']) {
      
      let adjacent = move(currentNode, direction);

      // if not visited yet and is valid node then add it to stack
      if(!visited[adjacent] && validNodes.some(node => compare(node, adjacent))) {
        console.log(`  Adding node ${adjacent} to stack.`);
        stack.push(adjacent);
      }
    }
  }
}
