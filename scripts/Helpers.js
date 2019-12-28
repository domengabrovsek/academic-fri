//
// Matrix utility functions
//
// mvPush   ... push current matrix on matrix stack
// mvPop    ... pop top matrix from stack
// degToRad ... convert degrees to radians
//
function mvPushMatrix() {
  var copy = mat4.create();
  mat4.set(mvMatrix, copy);
  mvMatrixStack.push(copy);
}

function mvPopMatrix() {
  if (mvMatrixStack.length == 0) {
    throw "Invalid popMatrix!";
  }
  mvMatrix = mvMatrixStack.pop();
}

function degToRad(degrees) {
  return degrees * Math.PI / 180;
}

function generatePoint(x, y, z = 0) {
  return {
    x: x,
    z: z,
    y: y,
    tX: x,
    tY: y
  };
}

function generateTriangle({ aX, aY, bX, bY, cX, cY}) {
  return [
    generatePoint(aX, aY),
    generatePoint(bX, bY),
    generatePoint(cX, cY)
  ];
}

function filterCoordinates(coordinates) {
  let vertexCoordinates = [];
  let textureCoordinates = [];
  let vertexCount = 0;

  coordinates.map(triangle => triangle
    .forEach(point => {
      Object.keys(point)
        .forEach(key => {
          if(["x", "y", "z"].includes(key)) {
            vertexCoordinates.push(point[key])
          } else if(["tX", "tY"].includes(key)) {
            textureCoordinates.push(point[key]);
          }
        })

      // increase vertex count
      vertexCount += 1;

    }));
      
  return {
    vertexCoordinates,
    textureCoordinates,
    vertexCount
  };
}