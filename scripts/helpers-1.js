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

function generatePoint({ x, y, z, d, m }) {

  // we need mode and direction to correctly set texture coordinates (tX, tY)

  let tX, tY;

  // we are drawing floor
  if(m === 'f') {
    tX = x;
    tY = y;
  }

  // we are drawing wall
  else if(m === 'w') {

    // draw in x direction
    if(d === 'x') {
      tX = z,
      tY = x
    }

    // draw in y direction
    else if(d === 'y') {
      tX = z,
      tY = y
    }
  }

  return {
    x: x,
    z: z,
    y: y,
    tX: tX, 
    tY: tY
  };
}

function generateTriangle({ aX, aY, aZ, bX, bY, bZ, cX, cY, cZ, d, m}) {
  return [
    generatePoint({ x: aX, y: aY, z: aZ, d, m }),
    generatePoint({ x: bX, y: bY, z: bZ, d, m }),
    generatePoint({ x: cX, y: cY, z: cZ, d, m })
  ];
}

/**
 * Returns an array of polygons(triangles).
 * @param {Object} Object which contains properties needed to generate several squares.
 * @param {number} x represents x coordinate
 * @param {number} y represents y coordinate
 * @param {number} z represents z coordinate
 * @param {number} l represents length of square
 * @param {number} n represents number of squares to generate
 * @param {number} m is used to set mode what to draw w for wall, f for floor
 */
function generateSquares({ x, y, z, l, n, m, d}) {

  let squares = [];

  // we are drawing in x direction
  if(d === 'x') {
    n = n + x

    for(x; x < n; x++) {
      squares.push(...generateSquare({ x, y, z, l, m, d }))
    }
  }

  // we are drawing in y direction
  else if(d === 'y') {
    n = n + y;

    for(y; y < n; y++) {
      squares.push(...generateSquare({ x, y, z, l, m, d }))
    }
  }

  return squares;
}

/**
 * Returns an array of polygons(triangles) which form a square.
 * @param {Object} Object which contains properties needed to generate several squares.
 * @param {number} x represents x coordinate
 * @param {number} y represents y coordinate
 * @param {number} z represents z coordinate
 * @param {number} l represents length of square
 * @param {number} n represents number of squares to generate
 * @param {string} m is used to set mode what to draw w for wall, f for floor
 * @param {number} d is used to set direction of drawing, either x or y
 */
function generateSquare({ x, y, z, l, d, m }) {
  
  // m: f(loor), w(all)

  let t1, t2, A, B, C, D; 

  // we are drawing floor
  if(m === 'f') {

    // calculate verteces for square
    A = { x: x, y: y, z: z };
    B = { x: x + l, y: y, z: z };
    C = { x: x, y: y + l, z: z };
    D = { x: x + l, y: y + l, z: z }; 
  }

  // we are drawing wall
  else if(m === 'w') {

    // we can draw in x or y direction


    // we are drawing in x direction
    if(d === 'x') {
      // calculate verteces for square
      A = { x: x, y: y, z: z };
      B = { x: x + l, y: y, z: z };
      C = { x: x, y: y, z: z - l };
      D = { x: x + l, y: y, z: z - l };
    }

    // we are drawing in y direction
    else if(d === 'y') {
      // calculate verteces for square
      A = { x: x, y: y, z: z };
      B = { x: x, y: y + l, z: z };
      C = { x: x, y: y, z: z - l };
      D = { x: x, y: y + l, z: z - l };
    }
  }

  // two triangles form a square 
  t1 = generateTriangle({ 
    aX: A.x, aY: A.y, aZ: A.z, 
    bX: C.x, bY: C.y, bZ: C.z, 
    cX: D.x, cY: D.y, cZ: D.z,
    d, m 
  });  

  t2 = generateTriangle({ 
    aX: A.x, aY: A.y, aZ: A.z, 
    bX: B.x, bY: B.y, bZ: B.z,
    cX: D.x, cY: D.y, cZ: D.z,
    d, m 
  });  

  // console.log(A, B, C, D);

  return [t1, t2];
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