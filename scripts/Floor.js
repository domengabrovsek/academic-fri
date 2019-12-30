var floorVertexPositionBuffer;
var floorVertexTextureCoordBuffer;
var floorVertexIndexBuffer;

var floorINVertexPositionBuffer;
var floorINVertexTextureCoordBuffer;
var floorINVertexIndexBuffer;

function initBuffersFloor() {

  // TODO REMOVE ----------------------------------------------------------

  let floorStartData = [generateTriangle({ 
    aX: 0, aY: 0, aZ: 0,
    bX: 0, bY: 0, bZ: 0,
    cX: 0, cY: 0, cZ: 0,
    m: 'f' 
  })];

  // get coordinates to draw start floor
  var { vertexCoordinates, textureCoordinates, vertexCount } = filterCoordinates(floorStartData);

  floorVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, floorVertexPositionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexCoordinates), gl.STATIC_DRAW);
  floorVertexPositionBuffer.itemSize = 3;
  floorVertexPositionBuffer.numItems = vertexCount;

  floorVertexTextureCoordBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, floorVertexTextureCoordBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(textureCoordinates), gl.STATIC_DRAW);
  floorVertexTextureCoordBuffer.itemSize = 2;
  floorVertexTextureCoordBuffer.numItems = vertexCount;

  // ----------------------------------------------------------

  // floor
  let floor = generateSquare({x: -13, y: -13, z: 0, l: 26, m: 'f' });


  // ceiling
  floor.push(...generateSquare({x: -13, y: -13, z: 1, l: 26, m: 'f' }))

  // get coordinates to draw floor
  var { vertexCoordinates, textureCoordinates, vertexCount } = filterCoordinates(floor);

  floorINVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, floorINVertexPositionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexCoordinates), gl.STATIC_DRAW);
  floorINVertexPositionBuffer.itemSize = 3;
  floorINVertexPositionBuffer.numItems = vertexCount;

  floorINVertexTextureCoordBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, floorINVertexTextureCoordBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(textureCoordinates), gl.STATIC_DRAW);
  floorINVertexTextureCoordBuffer.itemSize = 2;
  floorINVertexTextureCoordBuffer.numItems = vertexCount;
}

function drawFloor() {
  // Activate textures
  var copy = mat4.create(); //naredi novo matriko
  mat4.set(mvMatrix, copy); //shrani trenutno matriko

  gl.activeTexture(gl.TEXTURE0);
  gl.bindTexture(gl.TEXTURE_2D, floorTexture);
  gl.uniform1i(shaderProgram.samplerUniform, 0);

  // Set the texture coordinates attribute for the vertices.
  gl.bindBuffer(gl.ARRAY_BUFFER, floorVertexTextureCoordBuffer);
  gl.vertexAttribPointer(shaderProgram.textureCoordAttribute, floorVertexTextureCoordBuffer.itemSize, gl.FLOAT, false, 0, 0);

  // Draw the floor by binding the array buffer to the floor's vertices
  // array, setting attributes, and pushing it to GL.
  gl.bindBuffer(gl.ARRAY_BUFFER, floorVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, floorVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);

  // Draw the cube.
  setMatrixUniforms();
  gl.drawArrays(gl.TRIANGLES, 0, floorVertexPositionBuffer.numItems);

  gl.activeTexture(gl.TEXTURE0);
  gl.bindTexture(gl.TEXTURE_2D, floorTexture);
  gl.uniform1i(shaderProgram.samplerUniform, 0);

  // Set the texture coordinates attribute for the vertices.
  gl.bindBuffer(gl.ARRAY_BUFFER, floorINVertexTextureCoordBuffer);
  gl.vertexAttribPointer(shaderProgram.textureCoordAttribute, floorINVertexTextureCoordBuffer.itemSize, gl.FLOAT, false, 0, 0);

  // Draw the floor by binding the array buffer to the floor's vertices
  // array, setting attributes, and pushing it to GL.
  gl.bindBuffer(gl.ARRAY_BUFFER, floorINVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, floorINVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);

  // Draw the cube.
  setMatrixUniforms();
  gl.drawArrays(gl.TRIANGLES, 0, floorINVertexPositionBuffer.numItems);

  mat4.set(copy, mvMatrix); //nastavi prejsno matriko
}