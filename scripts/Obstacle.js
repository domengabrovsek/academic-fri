
var cubeVertexPositionBuffer;
var cubeVertexTextureCoordBuffer;
var cubeVertexIndexBuffer;

var cubeDVertexPositionBuffer;
var cubeDVertexTextureCoordBuffer;
var cubeDVertexIndexBuffer;

var obstacles = [
    { x: -6.5, y: -2.5 },
    { x: -8, y: -0.3 },
    { x: -10.4, y: 2.4 },
    { x: -7.8, y: 4.2 },
    { x: -11.5, y: 7.7 },
    { x: -4.2, y: -0.6 },

    { x: -8, y: -8.6 },
    { x: -5.7, y: -10.1 },
    { x: -0, y: 4.8 },

    { x: 12.5, y: -5 },
    { x: -5.8, y: 8.7 },
    { x: -2, y: -11.8 },
    { x: -0.2, y: -7.7 },
    { x: 3.6, y: -4.9 },
    { x: 8.1, y: -1.1 },
    { x: 6.3, y: -7.9 },
];

function initBuffersObstacles() {

    // Create a buffer for the cube's vertices.
    cubeVertexPositionBuffer = gl.createBuffer();

    // Select the cubeVertexPositionBuffer as the one to apply vertex
    // operations to from here out.
    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVertexPositionBuffer);

    // Now create an array of vertices for the cube.
    vertices = [
        // Front face
        -0.25, -0.25,  0.25,
        0.25, -0.25,  0.25,
        0.25,  0.25,  0.25,
        -0.25,  0.25,  0.25,

        // Back face
        -0.25, -0.25, -0.25,
        -0.25,  0.25, -0.25,
        0.25,  0.25, -0.25,
        0.25, -0.25, -0.25,

        // Top face
        -0.25,  0.25, -0.25,
        -0.25,  0.25,  0.25,
        0.25,  0.25,  0.25,
        0.25,  0.25, -0.25,

        // Bottom face
        -0.25, -0.25, -0.25,
        0.25, -0.25, -0.25,
        0.25, -0.25,  0.25,
        -0.25, -0.25,  0.25,

        // Right face
        0.25, -0.25, -0.25,
        0.25,  0.25, -0.25,
        0.25,  0.25,  0.25,
        0.25, -0.25,  0.25,

        // Left face
        -0.25, -0.25, -0.25,
        -0.25, -0.25,  0.25,
        -0.25,  0.25,  0.25,
        -0.25,  0.25, -0.25
    ];

    // Now pass the list of vertices into WebGL to build the shape. We
    // do this by creating a Float32Array from the JavaScript array,
    // then use it to fill the current vertex buffer.
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
    cubeVertexPositionBuffer.itemSize = 3;
    cubeVertexPositionBuffer.numItems = 24;

    // Now set up the colors for the vertices. We'll use solid colors
    // Map the texture onto the cube's faces.
    cubeVertexTextureCoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVertexTextureCoordBuffer);

    var textureCoordinates = [
        // Front
        0.0,  0.0,
        1.0,  0.0,
        1.0,  1.0,
        0.0,  1.0,
        // Back
        0.0,  0.0,
        1.0,  0.0,
        1.0,  1.0,
        0.0,  1.0,
        // Top
        0.0,  0.0,
        1.0,  0.0,
        1.0,  1.0,
        0.0,  1.0,
        // Bottom
        0.0,  0.0,
        1.0,  0.0,
        1.0,  1.0,
        0.0,  1.0,
        // Right
        0.0,  0.0,
        1.0,  0.0,
        1.0,  1.0,
        0.0,  1.0,
        // Left
        0.0,  0.0,
        1.0,  0.0,
        1.0,  1.0,
        0.0,  1.0
    ];

    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(textureCoordinates), gl.STATIC_DRAW);
    cubeVertexTextureCoordBuffer.itemSize = 2;
    cubeVertexTextureCoordBuffer.numItems = 24;

    // Build the element array buffer; this specifies the indices
    // into the vertex array for each face's vertices.
    cubeVertexIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer);

    // This array defines each face as two triangles, using the
    // indices into the vertex array to specify each triangle's
    // position.
    var cubeVertexIndices = [
        0, 1, 2,      0, 2, 3,    // Front face
        4, 5, 6,      4, 6, 7,    // Back face
        8, 9, 10,     8, 10, 11,  // Top face
        12, 13, 14,   12, 14, 15, // Bottom face
        16, 17, 18,   16, 18, 19, // Right face
        20, 21, 22,   20, 22, 23  // Left face
    ];

    // send the element array to GL
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW);
    cubeVertexIndexBuffer.itemSize = 1;
    cubeVertexIndexBuffer.numItems = 36;

}

function drawObstacle({ x, y } = {}) {

    let z = 0.25;

    var copy = mat4.create(); 
    mat4.set(mvMatrix, copy); 
    
    mat4.translate(mvMatrix, [x, z, y]);

    // Now move the drawing position a bit to where we want to start
    // drawing the cube.
    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVertexPositionBuffer);
    gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, cubeVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);

    // Set the texture coordinates attribute for the vertices.
    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVertexTextureCoordBuffer);
    gl.vertexAttribPointer(shaderProgram.textureCoordAttribute, cubeVertexTextureCoordBuffer.itemSize, gl.FLOAT, false, 0, 0);

    // Specify the texture to map onto the faces.
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, obstacleTexture);
    gl.uniform1i(shaderProgram.samplerUniform, 0);

    // Draw the cube.
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer);
    setMatrixUniforms();
    gl.drawElements(gl.TRIANGLES, cubeVertexIndexBuffer.numItems, gl.UNSIGNED_SHORT, 0);

    mat4.set(copy, mvMatrix);
}

function drawObstacles() {

    obstacles.forEach(obstacle => drawObstacle(obstacle))    
}