
function mvPushMatrix() {
  var copy = mat4.create();
  mat4.set(mvMatrix, copy);
  mvMatrixStack.push(copy);
}

function mvPopMatrix() {
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

function getQuadrant(x, y) {

  /*
    1 2 3 4
    5 6 7 8
    9 10 11 12
    13 14 15 16

  */

  // first row
  if(y >= -13 && y <= -7) {
    // quadrant 1
    if(x >= -13 && x <= -7) return 1;
    if(x > -7 && x <= 0) return 2;
    if(x > 0 && x <= 7) return 3;
    if(x > 7 && x <= 13) return 4;
  }

  // second row 
  if(y > -7 && y <= 0) {
    if(x >= -13 && x <= -7) return 5;
    if(x > -7 && x <= 0) return 6;
    if(x > 0 && x <= 7) return 7;
    if(x > 7 && x <= 13) return 8;
  }

  // third row
  if(y > 0 && y <= 7) {
    if(x >= -13 && x <= -7) return 9;
    if(x > -7 && x <= 0) return 10;
    if(x > 0 && x <= 7) return 11;
    if(x > 7 && x <= 13) return 12;
  }

  // fourth row
  if(y > 7 && y < 13) {
    if(x >= -13 && x <= -7) return 13;
    if(x > -7 && x <= 0) return 14;
    if(x > 0 && x <= 7) return 15;
    if(x > 7 && x <= 13) return 16;
  }
}

function detectCollision() {

  // first check in which quadrant the player is
  let quadrant = getQuadrant(xPosition, yPosition);
  let collision = getCollision(cdWalls[quadrant]);
  
  // console.log('collision: ', collision);

  return collision;
}


function detectEndGame({x,y,e}) {

  let isEndGame = false;
  
  const xPlusError = x + e;
  const xMinusError = x - e;
  const yPlusError = y + e;
  const yMinusError = y - e;

  if((xPosition >= xMinusError && xPosition <= xPlusError) && (yPosition >= yMinusError && yPosition <= yPlusError)) {
      isEndGame = true;
  }

  return isEndGame;
}

function getCollision (input)  {

  // error is used to detect collision on both sides of wall
  let error = 0.3;
  let collision = false;
  //console.log("Input: ", input);

  for(let point of input) {

    // console.clear();
    // console.log(`Player: x:${xPosition}, y: ${yPosition}`);
  
    const xPlusError = point.x + error;
    const xMinusError = point.x - error;
    const yPlusError = point.y + error;
    const yMinusError = point.y - error;

    // console.log(`X: ${xMinusError} <= ${xPosition} <= ${xPlusError}`);
    // console.log(`Y: ${yMinusError} <= ${yPosition} <= ${yMinusError}`);

    if((xPosition >= xMinusError && xPosition <= xPlusError) && (yPosition >= yMinusError && yPosition <= yPlusError)) {
      collision = true;
      break;
    }
  }

  return collision;

}
function prepareCollisionDetectionData(walls) {

  let dividedWalls = [];

  let filteredPoints = [];

  walls.forEach(wall => {
    wall.forEach(point => {
      if(!filteredPoints.some(fp => fp.x === point.x && fp.y === point.y)) {
        let p = {x: point.x, y: point.y};
        let quadrant = getQuadrant(p.x, p.y)
        filteredPoints.push(p);

        if(!dividedWalls[quadrant]) {
          dividedWalls[quadrant] = [];
        }

        dividedWalls[quadrant].push(p);
      }
    })
  })

  return dividedWalls;
}