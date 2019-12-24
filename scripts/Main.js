// Global variables

// game canvas
let canvas;

let start = true;

var gl;
var shaderProgram;
var dovoljenje = true; // pomaga za skok
var stevec = 0; // pomaga pri času skoka

var skok = false;
var konec = false;

// Buffers
var worldVertexPositionBuffer = null;
var worldVertexTextureCoordBuffer = null;

var floorTexture;
var floorTexture;

// Model-view and projection matrix and model-view matrix stack
var mvMatrixStack = [];
var mvMatrix = mat4.create();

var pMatrix = mat4.create();

// Variables for storing textures
var wallTexture;

// Variable that stores  loading state of textures.
var texturesLoaded = false;

// Keyboard handling helper variable for reading the status of keys
var currentlyPressedKeys = {};

// Variables for storing current position and speed
var pitch = 0;
var pitchRate = 0;
var yaw = 0;
var yawRate = 0;
var xPosition = 0;
var yPosition = 0.4;
var zPosition = 0;
var speed = 0;

// Used to make us "jog" up and down as we move forward.
var joggingAngle = 0;

// Helper variable for animation
var lastTime = 0;

// Initialize the textures we'll be using, then initiate a load of
// the texture images. The handleTextureLoaded() callback will finish
// the job; it gets called each time a texture finishes loading.
//
function initTextures() {
  wallTexture = gl.createTexture();
  wallTexture.image = new Image();
  wallTexture.image.onload = () => handleTextureLoaded(wallTexture);
  wallTexture.image.src = "./images/wall.png";

  floorTexture = gl.createTexture();
  floorTexture.image = new Image();
  floorTexture.image.onload = () => handleTextureLoaded(floorTexture);
  floorTexture.image.src = "./images/grass.png";

  floorTexture = gl.createTexture();
  floorTexture.image = new Image();
  floorTexture.image.onload = () => handleTextureLoaded(floorTexture);
  floorTexture.image.src = "./images/floor.png";
}

function handleTextureLoaded(texture) {
  gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);

  // Third texture usus Linear interpolation approximation with nearest Mipmap selection
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, texture.image);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
  gl.generateMipmap(gl.TEXTURE_2D);

  gl.bindTexture(gl.TEXTURE_2D, null);

  // when texture loading is finished we can draw scene.
  texturesLoaded = true;
}

//
// handleLoadedWorld
//
// Initialisation of world 
//
function handleLoadedWorld(data) {
  var lines = data.split("\n");
  var vertexCount = 0;
  var vertexPositions = [];
  var vertexTextureCoords = [];
  for (var i in lines) {
    var vals = lines[i].replace(/^\s+/, "").split(/\s+/);
    if (vals.length == 5 && vals[0] != "//") {
      // It is a line describing a vertex; get X, Y and Z first
      vertexPositions.push(parseFloat(vals[0]));
      vertexPositions.push(parseFloat(vals[1]));
      vertexPositions.push(parseFloat(vals[2]));

      // And then the texture coords
      vertexTextureCoords.push(parseFloat(vals[3]));
      vertexTextureCoords.push(parseFloat(vals[4]));

      vertexCount += 1;
    }
  }

  worldVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, worldVertexPositionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexPositions), gl.STATIC_DRAW);
  worldVertexPositionBuffer.itemSize = 3;
  worldVertexPositionBuffer.numItems = vertexCount;

  worldVertexTextureCoordBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, worldVertexTextureCoordBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertexTextureCoords), gl.STATIC_DRAW);
  worldVertexTextureCoordBuffer.itemSize = 2;
  worldVertexTextureCoordBuffer.numItems = vertexCount;

}

//
// loadWorld
//
// Loading world 
//
function loadWorld() {
  //zid
  var request = new XMLHttpRequest();
  request.open("GET", "./images/world.txt");
  request.onreadystatechange = function () {
    if (request.readyState == 4) {
      handleLoadedWorld(request.responseText);
    }
  };
  request.send();
}

function drawScene() {

  // set the rendering environment to full canvas size
  gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
  // Clear the canvas before we start drawing on it.
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

  // If buffers are empty we stop loading the application.
  if (worldVertexTextureCoordBuffer == null || worldVertexPositionBuffer == null) {
    return;
  }

  // Establish the perspective with which we want to view the
  // scene. Our field of view is 45 degrees, with a width/height
  // ratio of 640:480, and we only want to see objects between 0.1 units
  // and 100 units away from the camera.
  mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.5, 100.0, pMatrix);

  // Set the drawing position to the "identity" point, which is
  // the center of the scene.
  mat4.identity(mvMatrix);

  // Now move the drawing position a bit to where we want to start
  // drawing the world.
  mat4.rotate(mvMatrix, degToRad(-pitch), [1, 0, 0]);
  mat4.rotate(mvMatrix, degToRad(-yaw), [0, 1, 0]);
  mat4.translate(mvMatrix, [-xPosition, -yPosition, -zPosition]);

  // Activate textures
  gl.activeTexture(gl.TEXTURE0);
  gl.bindTexture(gl.TEXTURE_2D, wallTexture);
  gl.uniform1i(shaderProgram.samplerUniform, 0);

  // Set the texture coordinates attribute for the vertices.
  gl.bindBuffer(gl.ARRAY_BUFFER, worldVertexTextureCoordBuffer);
  gl.vertexAttribPointer(shaderProgram.textureCoordAttribute, worldVertexTextureCoordBuffer.itemSize, gl.FLOAT, false, 0, 0);

  // Draw the world by binding the array buffer to the world's vertices
  // array, setting attributes, and pushing it to GL.
  gl.bindBuffer(gl.ARRAY_BUFFER, worldVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, worldVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);

  // Draw the cube.
  setMatrixUniforms();
  gl.drawArrays(gl.TRIANGLES, 0, worldVertexPositionBuffer.numItems);

}

// Called every time before redeawing the screen.
function animate() {
  var timeNow = new Date().getTime();
  if (lastTime != 0) {
    var elapsed = timeNow - lastTime;

    if (speed != 0) {
      var oldX = xPosition;
      var oldZ = zPosition;

      xPosition -= Math.sin(degToRad(yaw)) * speed * elapsed;
      zPosition -= Math.cos(degToRad(yaw)) * speed * elapsed;
      joggingAngle += elapsed * 0.6;

      if (zPosition < -9 && xPosition < 0.9 && xPosition > -0.9 && skatla) {
        zPosition = oldZ;
      }

      if (zPosition < 15.9 && zPosition > 15.0 && xPosition < -1 && xPosition > -1.3 && !skok && !pobranKljuc2) {
        xPosition = oldX;

      } else if (zPosition < 15.9 && zPosition > 15.0 && xPosition < -2.4 && xPosition > -2.6 && !skok && pobranKljuc2) {

        xPosition = oldX;
      }

      if (stevec == 0) { // dodamo da nam ne pokvari skoka
        yPosition = Math.sin(degToRad(joggingAngle)) / 20 + 0.4
      }
    }

    yaw += yawRate * elapsed;
    pitch += pitchRate * elapsed;

  }
  lastTime = timeNow;
}

function handleKeyDown(event) {
  // storing the pressed state for individual key
  currentlyPressedKeys[event.keyCode] = true;
}

function handleKeyUp(event) {
  // reseting the pressed state for individual key
  currentlyPressedKeys[event.keyCode] = false;

  if (event.keyCode == 32) {
    dovoljenje = true;
    if (stevec != 0) { // ce skok ni dokoncan, pades na zacetno vrednost yPostiion
      yPosition = 0.4;
    }
    stevec = 0;
    skok = false;
  }
}

// Called every time before redeawing the screen for keyboard
// input handling. Function continuisly updates helper variables.
function handleKeys() {
  if (currentlyPressedKeys[33]) {
    // Page Up
    pitchRate = 0.1;
  } else if (currentlyPressedKeys[34]) {
    // Page Down
    pitchRate = -0.1;
  } else {
    pitchRate = 0;
  }

  if (currentlyPressedKeys[65]) {
    // Left cursor key or A
    yawRate = 0.1;
  } else if (currentlyPressedKeys[68]) {
    // Right cursor key or D
    yawRate = -0.1;
  } else {
    yawRate = 0;
  }

  if (currentlyPressedKeys[87]) {
    // Up cursor key or W
    speed = 0.003;
  } else if (currentlyPressedKeys[83]) {
    // Down cursor key
    speed = -0.003;
  } else {
    speed = 0;
  }

  if (currentlyPressedKeys[32] && dovoljenje) { //"space", za skok.
    stevec++;
    if (stevec < 10) {
      yPosition += 0.04;
    }
    if (stevec > 10) {
      if (yPosition - 0.04 > 0.4)
        yPosition -= 0.04;

    }
    skok = true;

  }
  if (currentlyPressedKeys[67]) { //"c", za sklont. Ce drzis in se premikas, hodis sklonjen. Ce samo prtisnes se sklonis.
    yPosition = 0.21;
  }
}

function vmes() {

  setInterval(function () {
    if (texturesLoaded) { // only draw scene and animate when textures are loaded.

      if (stevec > 20) { // za skok
        dovoljenje = false;
        stevec = 0;
      }

      if (!konec) { //dokler ni konec igre lahko opravlamo
        requestAnimationFrame(animate);
        handleKeys();
      }

      drawScene(); // najprej narisemo svet, potem pa razlicne objetke
      drawFloor();

      if (konec) {
        gameover();
      }
    }
  }, 15);
}

function startGame() {
  canvas = document.getElementById("canvas");

  // Initialize the GL context
  gl = initGL(canvas); 

  // Only continue if WebGL is available and working
  if (gl) {
    gl.clearColor(0.0, 0.0, 0.0, 1.0); // Set clear color to black, fully opaque
    gl.clearDepth(1.0); // Clear everything
    gl.enable(gl.DEPTH_TEST); // Enable depth testing
    gl.depthFunc(gl.LEQUAL); // Near things obscure far things

    initShaders();
    initTextures();
    initBuffersTla(gl);

    // Initialise world objects
    loadWorld();

    // keyboard bindings
    document.onkeydown = handleKeyDown;
    document.onkeyup = handleKeyUp;

    drawScene();
    drawFloor();
      
    vmes();
  }
}