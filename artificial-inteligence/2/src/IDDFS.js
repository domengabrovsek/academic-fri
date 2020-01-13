'use strict';

const { constructPath, compare, move } = require('./helpers');

module.exports = function IDDFS(graph, startNode, endNodes) {

  let steps = 0;

  // main loop which iterates by depth of graph
  for(let depthLimit = 0; depthLimit < graph.length; depthLimit++) {
    console.log('\nCurrent depth limit: ', depthLimit);

    let visited = [];
    let parents = {};
    let stack = [];

    // start node
    parents[startNode] = null;
    visited[startNode] = true;
    stack.push(startNode);
    steps++;
    console.log(`  Adding node ${startNode} to stack.`);

    // while we have elements on stack we iterate
    while(stack.length > 0) {

      // stack.peek()
      let currentNode = stack[stack.length - 1];

      // if we found the final node
      if(endNodes.some(node => compare(node, currentNode))) {
        return { path: constructPath(currentNode, parents), steps };
      }

      let found = false;

      // if depth limit allows then check children
      if(stack.length <= depthLimit) {

        // check adjacent nodes (children)
        for(let direction of ['up', 'right', 'down', 'left']) {
                              
          let adjacent = move(currentNode, direction);

          // if not visited yet and is valid node then add it to stack
          if(!visited[adjacent] && graph.some(node => compare(node, adjacent))) {
            visited[adjacent] = true;
            parents[adjacent] = currentNode;
            stack.push(adjacent);
            steps++;
            console.log(`  Adding node ${adjacent} to stack.`);

            found = true;
            break;
          }
        }
      }

      if(!found) {
        stack.pop();
        console.log(`  Removing node ${currentNode} from stack.`);
      }
    }

    console.log('-------------------------------------------------');
  }
}
