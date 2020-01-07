'use strict';

function move(node, direction) {

  switch(direction) {
    case 'right': {
      return [node[0], node[1] + 1];
    }
    case 'left': {
      return [node[0], node[1] - 1];
    }
    case 'up': {
      return [node[0] - 1, node[1]];    
    }
    case 'down': {
      return [node[0] + 1, node[1]];    
    }
  }  
}

function findStartEnd(graph) {
  
  let startNode, endNodes = [];

  for(let i = 0; i < graph.length; i++) {
    for(let j = 0; j < graph[i].length; j++) {
      if(graph[i][j] == '-2') {
        startNode = [i,j];
      }

      if(graph[i][j] === '-3') {
        endNodes.push([i, j])
      } 
    }
  }

  return {
    startNode,
    endNodes
  }
}

function transform(matrix) {

  let transformedMatrix = [];

  // split by rows and remove empty rows
  let rows = matrix
    .split('\n')
    .filter(row => row.length > 0);

  for(let i = 0; i < rows.length; i++) {

    let elements = rows[i].split(',');

    if(!transformedMatrix[i]) {
      transformedMatrix[i] = [];
    }

    for(let j = 0; j < elements.length; j++) {
      transformedMatrix[i][j] = parseInt(elements[j]).toString();
    }
  }

  return transformedMatrix;
}

function isValidNode(graph, node) {
  return graph[node[0]][node[1]] !== '-1';
}

function getValidNodes(graph) {
  let validNodes = [];

  for(let i = 0; i < graph.length; i++) {
    for(let j = 0; j < graph[i].length; j++) {
      if(isValidNode(graph, [i, j])) {
        validNodes.push([i, j]);
      }
    }
  }

  return validNodes;
}

function getAdjMatrix(graph) {

  let adjMatrix = {};
  let validNodes = getValidNodes(graph);

  for(let i = 0; i < validNodes.length; i++) {

    if(!adjMatrix[validNodes[i]]) {
      adjMatrix[validNodes[i]] = [];
    }

    // if node above is valid
    if(isValidNode(graph, move(validNodes[i], 'up'))) {
      adjMatrix[validNodes[i]].push(move(validNodes[i], 'up'));
    }

    // if node right is valid
    if(isValidNode(graph, move(validNodes[i], 'right'))) {
      adjMatrix[validNodes[i]].push(move(validNodes[i], 'right'));
    }

    // if node down is valid
    if(isValidNode(graph, move(validNodes[i], 'down'))) {
      adjMatrix[validNodes[i]].push(move(validNodes[i], 'down'));
    }

    // if node left is valid
    if(isValidNode(graph, move(validNodes[i], 'left'))) {
      adjMatrix[validNodes[i]].push(move(validNodes[i], 'left'));
    }
  }

  return adjMatrix;
}

function getParent(matrix, node) {
  
    for(let parent of Object.keys(matrix)) {
      for(let child of matrix[parent]) {
        if(compare(child, node)) {
          return parent;
        }
      }
    }
}

function compare(arr1, arr2) {
  return arr1[0] === arr2[0] && arr1[1] === arr2[1];
}

module.exports = {
  transform,
  findStartEnd,
  move,
  getAdjMatrix,
  getParent,
  compare,
  isValidNode
};
