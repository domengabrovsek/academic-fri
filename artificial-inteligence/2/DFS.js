'use strict';

const Stack = require('stack-lifo');
const { moveUp, moveDown, moveLeft, moveRight, compare } = require('./helpers');

module.exports = function DFS(graph, startNode, endNodes) {

  let visited = [];
  let parents = {};

  let stack = new Stack();

  // start node
  parents[startNode] = [-1, -1];
  visited[startNode] = true;

  stack.push(startNode);

  while(!stack.isEmpty()) {

    // set first node 
    let currentNode = stack.peek();

    console.log('current: ', currentNode);

    // if we found the final node
    if(endNodes.some(node => compare(node, currentNode))) {
      console.log('\nvisited: ', visited);
      console.log('\nparents: ');
      Object.keys(parents).forEach(key => console.log(key, parents[key]));
      return console.log('Victory!');
    }

    // if we didnt find the final node
    let found = false;

    for(let node of graph[currentNode]) {
      
      // if node was not visited yet
      if(!visited[node]) {

        visited[node] = true;
        parents[node] = currentNode;
        stack.push(node);

        console.log(`Adding node ${node} to stack.`);

        found = true;
        break;

      }

      if(!found) {
        stack.pop();
        console.log(`Removing node ${node} from stack.`);
      }
    }
  }

  console.log('\nvisited: ', visited);
  
  console.log('\nparents: ');
  Object.keys(parents).forEach(key => console.log(key, parents[key]));


}