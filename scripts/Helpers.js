
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
    tY: tY,
    d: d
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

function detectCollision(xPosition, yPosition) {

  // first check in which quadrant the player is
  let quadrant = getQuadrant(xPosition, yPosition);
  let collision = getCollision(cdWalls[quadrant]);

  return collision;
}

function detectBox({ x,y,e }) {

  let isBoxDetected = false;
  
  const xPlusError = x + e;
  const xMinusError = x - e;
  const yPlusError = y + e;
  const yMinusError = y - e;

  if((xPosition >= xMinusError && xPosition <= xPlusError) && (yPosition >= yMinusError && yPosition <= yPlusError)) {
    isBoxDetected = true;
  }

  return isBoxDetected;
}

function spawnRandomElement() {

  let minX = -12.5,
      maxX = 12.5,
      minY = -12.5,
      maxY = 12.5;
  let randomX = parseFloat((Math.random() * (maxX - minX) + minX).toFixed(3));
  let randomY = parseFloat((Math.random() * (maxY - minY) + minY).toFixed(3));

  if(!detectCollision(randomX, randomY)) {
    console.log("Random: ", randomX, ": ", randomY);
    return {
      "x": randomX,
      "y": randomY,
      "e": 0.3 
    };
  } else {
    spawnRandomElement();
  }
}

function getDistance({x1,y1}, {x2,y2}) {
  return Math.sqrt(Math.pow((x2 - x1),2) + Math.pow((y2 - y1), 2));
}

function getCollision (input)  {

  // error is used to detect collision on both sides of wall
  let error = 0.62;
  let correction = 0.35;
  let collision = false;

  
  let maxX = input[0].x;
  let maxY = input[0].y;

  let minX = input[0].x;
  let minY = input[0].y;

  input.forEach(point => {
    if(point.x > maxX) maxX = point.x;
    if(point.x < maxX) minX = point.x;
    if(point.y > maxY) maxY = point.y;
    if(point.y < maxY) minY = point.y;
  })
  
  console.clear();

  console.log(`X: ${minX} <= ${xPosition} <= ${maxX}`);
  console.log(`Y: ${minY} <= ${yPosition} <= ${maxY}`);
  

  for(let point of input) {
  
    // console.log(point.x, point.y);
    
    let yPlusError = point.y + error;
    let yMinusError = point.y - error;
    let xPlusError = point.x + error;
    let xMinusError = point.x - error;

    // we are checking walls which were drawn in X or Y direction
    if(point.d === 'x') {
      // yPlusError -= correction;
      // yMinusError += correction;
    } else if(point.d === 'y') {
      // xPlusError -= correction;
      // xMinusError += correction;
    }

    if((xPosition >= xMinusError && xPosition <= xPlusError) && (yPosition >= yMinusError && yPosition <= yPlusError)) {
      collision = true;
      console.log(`X: ${xMinusError} <= ${xPosition} <= ${xPlusError}`);
      console.log(`Y: ${yMinusError} <= ${yPosition} <= ${yPlusError}`);
      console.log(`Collision at (${xPosition}, ${yPosition})`);
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
        let p = {x: point.x, y: point.y, d: point.d};
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