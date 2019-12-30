var floorVertexPositionBuffer;
var floorVertexTextureCoordBuffer;
var floorVertexIndexBuffer;

var floorINVertexPositionBuffer;
var floorINVertexTextureCoordBuffer;
var floorINVertexIndexBuffer;

function initBuffersFloor() {

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
  var copy = mat4.create(); // create new matrix
  mat4.set(mvMatrix, copy); // save current matrix

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

  mat4.set(copy, mvMatrix); // set previous matrix
}