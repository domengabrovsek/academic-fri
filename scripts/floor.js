var floorVertexPositionBuffer;
var floorVertexTextureCoordBuffer;
var floorVertexIndexBuffer;

var floorINVertexPositionBuffer;
var floorINVertexTextureCoordBuffer;
var floorINVertexIndexBuffer;


function initBuffersTla(gl) {
  var dataa = "";
  "3.5       0.0      -0.5    -0.5   3.5" + '\n' +
  "3.5     0.0     10.0    10.0   3.5" + '\n' +
  "10.0  0.0     10.0    10.0   10.0" + '\n' +
  "10.0  0.0     10.0    10.0   10.0" + '\n' +
  "10.0  0.0      -0.5    -0.5   10.0" + '\n' +
  "3.5    0.0      -0.5    -0.5   3.5" + '\n';

  var lineFloor = dataa.split("\n");
  var vertexCountFloor = 0;
  var vertexPositionsFloor = [];
  var vertexTextureCoordsFloor = [];
  for (var i in lineFloor) {
    var vals = lineFloor[i].replace(/^\s+/, "").split(/\s+/);
    if (vals.length == 5 && vals[0] != "//") {
      // It is a line describing a vertex; get X, Y and Z first
      vertexPositionsFloor.push(parseFloat(vals[0]));
      vertexPositionsFloor.push(parseFloat(vals[1]));
      vertexPositionsFloor.push(parseFloat(vals[2]));

      // And then the texture coords
      vertexTextureCoordsFloor.push(parseFloat(vals[3]));
      vertexTextureCoordsFloor.push(parseFloat(vals[4]));

      vertexCountFloor += 1;
    }
  }

  floorVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, floorVertexPositionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexPositionsFloor), gl.STATIC_DRAW);
  floorVertexPositionBuffer.itemSize = 3;
  floorVertexPositionBuffer.numItems = vertexCountFloor;

  floorVertexTextureCoordBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, floorVertexTextureCoordBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexTextureCoordsFloor), gl.STATIC_DRAW);
  floorVertexTextureCoordBuffer.itemSize = 2;
  floorVertexTextureCoordBuffer.numItems = vertexCountFloor;

  let { vertexCoordinates, textureCoordinates, vertexCount } = filterCoordinates(floor);

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