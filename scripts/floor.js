var floorVertexPositionBuffer;
var floorVertexTextureCoordBuffer;
var floorVertexIndexBuffer;

var floorINVertexPositionBuffer;
var floorINVertexTextureCoordBuffer;
var floorINVertexIndexBuffer;


function initBuffersTla(gl) {
    var dataa=   "3.5       0.0      -0.5    -0.5   3.5"+ '\n' +
                    "3.5     0.0     100.0    100.0   3.5"+ '\n' +
                    "100.0  0.0     100.0    100.0   100.0"+ '\n' +
                    "100.0  0.0     100.0    100.0   100.0"+ '\n' +
                    "100.0  0.0      -0.5    -0.5   100.0"+ '\n' +
                    "3.5    0.0      -0.5    -0.5   3.5"+ '\n'
    ;





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

    var dataaIN= // MAIN Floor 1
        "2.0  0.0  2.0  2.0  2.0" + '\n' +
        "2.0  0.0  -2.0 -2.0 2.0" + '\n' +
        "-2.0 0.0  2.0  2.0 -2.0" + '\n' +
        "-2.0 0.0  2.0  2.0 -2.0" + '\n' +
        "-2.0 0.0  -2.0  -2.0 -2.0" + '\n' +
        "2.0  0.0  -2.0 -2.0 2.0" + '\n' +

        // Tla za hodnik naravnost(prepad)
        "-1.0  0.0 -20.0 -20.0 -1.0" + '\n' +
        "-1.0  0.0  -2.0 -2.0 -1.0" + '\n' +
        "1.0  0.0  -2.0 -2.0 1.0" + '\n' +
        "-1.0  0.0 -20.0 -20.0 -1.0" + '\n' +
        " 1.0  0.0 -20.0 -20.0 1.0" + '\n' +
        " 1.0  0.0  -2.0  -2.0 1.0" + '\n' +

        //Tla za hodnik levo(krogla)
        "-30.0 0.0  1.0  1.0  -30.0" + '\n' +
        "-30.0 0.0 -1.0 -1.0  -30.0" + '\n' +
        "-2.0  0.0 -1.0 -1.0  -2.0" + '\n' +
        "-2.0  0.0 -1.0 -1.0  -2.0" + '\n' +
        "-2.0  0.0  1.0  1.0  -2.0" + '\n' +
        "-30.0 0.0  1.0  1.0  -30.0" + '\n'+
        //Tla zpred vrati
        "3.5 0.0  -0.5  -0.5  3.5" + '\n' +
        "3.5 0.0  0.5  0.5  3.5" + '\n' +
        "2.0  0.0 -0.5 -0.5  2.0" + '\n' +
        "2.0  0.0 -0.5 -0.5  2.0" + '\n' +
        "2.0  0.0  0.5  0.5  2.0" + '\n' +
        "3.5 0.0  0.5  0.5  3.5" + '\n' +
        //podn rova od zadi
        "-1.0 0.0  2.0 2.0 -1.0"  + '\n' +
        "-1.0  0.0  8.0 8.0 -1.0" + '\n' +
        "1.0  0.0  2.0 2.0 1.0" + '\n' +
        "1.0  0.0  2.0 2.0 1.0" + '\n' +
        "1.0  0.0  8.0 8.0 1.0" + '\n' +
        "-1.0  0.0  8.0 8.0 -1.0" + '\n' +
        //tla desnega rova
        "-1.0  0.0  6.0 6.0 -1.0"+ '\n' +
        "-8.0  0.0  6.0 6.0 -8.0"+ '\n' +
        "-8.0  0.0  8.0 8.0 -8.0"+ '\n' +
        "-8.0  0.0  8.0 8.0 -8.0"+ '\n' +
        "-1.0  0.0  8.0 8.0 -1.0"+ '\n' +
        "-1.0  0.0  6.0 6.0 -1.0"+ '\n' +


        //podn labirinta 1
        "1.0  0.0  6.0 6.0 1.0" + '\n' +
        "3.0  0.0  6.0 6.0 3.0" + '\n' +
        "3.0  0.0  18.0 18.0 3.0" + '\n' +
        "3.0  0.0  18.0 18.0 3.0" + '\n' +
        "1.0  0.0  18.0 18.0 1.0" + '\n' +
        "1.0  0.0  6.0  6.0 1.0" + '\n' +

        //podn labirinta 3

        "-1.0 0.0  12.0 12.0 -1.0" + '\n' +
        "-1.0  0.0  18.0 18.0 -1.0" + '\n' +
        "-6.0  0.0  12.0 12.0 -6.0" + '\n' +
        "-6.0  0.0  18.0 18.0 -6.0" + '\n' +
        "-6.0  0.0  12.0 12.0 -6.0" + '\n' +
        "-1.0  0.0  18.0 18.0 -1.0"+ '\n' +

    //podn labirinta 2
     "1.0 0.0  8.0 8.0 1.0" + '\n' +
    "-1.0  0.0  8.0 8.0 -1.0" + '\n' +
    "-1.0  0.0  18.0 18.0 -1.0" + '\n' +
    "-1.0  0.0  18.0 18.0 -1.0" + '\n' +
    "1.0  0.0  18.0 18.0 1.0" + '\n' +
    "1.0  0.0  8.0 8.0 1.0" ;


//notranji podn


    var lineFloorIN = dataaIN.split("\n");
    var vertexCountFloorIN = 0;
    var vertexPositionsFloorIN = [];
    var vertexTextureCoordsFloorIN = [];
    for (var i in lineFloorIN) {
        var vals = lineFloorIN[i].replace(/^\s+/, "").split(/\s+/);
        if (vals.length == 5 && vals[0] != "//") {
            // It is a line describing a vertex; get X, Y and Z first
            vertexPositionsFloorIN.push(parseFloat(vals[0]));
            vertexPositionsFloorIN.push(parseFloat(vals[1]));
            vertexPositionsFloorIN.push(parseFloat(vals[2]));

            // And then the texture coords
            vertexTextureCoordsFloorIN.push(parseFloat(vals[3]));
            vertexTextureCoordsFloorIN.push(parseFloat(vals[4]));

            vertexCountFloorIN += 1;
        }
    }

    floorINVertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, floorINVertexPositionBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexPositionsFloorIN), gl.STATIC_DRAW);
    floorINVertexPositionBuffer.itemSize = 3;
    floorINVertexPositionBuffer.numItems = vertexCountFloorIN;

    floorINVertexTextureCoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, floorINVertexTextureCoordBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexTextureCoordsFloorIN), gl.STATIC_DRAW);
    floorINVertexTextureCoordBuffer.itemSize = 2;
    floorINVertexTextureCoordBuffer.numItems = vertexCountFloorIN;
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
    gl.bindTexture(gl.TEXTURE_2D, metalTexture);
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

    mat4.set(copy,mvMatrix); //nastavi prejsno matriko
}