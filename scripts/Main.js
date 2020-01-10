// Global variables

// game canvas
let canvas;

let start = false;

var gl;
var shaderProgram;
var stevec = 0; // pomaga pri času skoka

var skok = false;
var konec = false;

// Buffers
var worldVertexPositionBuffer = null;
var worldVertexTextureCoordBuffer = null;
var elementVertexPositionBuffer = null;
var elementVertexTextureCoordBuffer = null;
var elementRoofVertexPositionBuffer = null;
var elementRoofVertexTextureCoordBuffer = null;

var floorTexture;
var floorTexture;

// Model-view and projection matrix and model-view matrix stack
var mvMatrixStack = [];
var mvMatrix = mat4.create();

var pMatrix = mat4.create();

// Variables for storing textures
var wallTexture;

// Random element texture
var randomTexture;

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
var yPosition = 0;
var zPosition = 0.4;
var speed = 0;

// Used to make us "jog" up and down as we move forward.
var joggingAngle = 0;

// Helper variable for animation
var lastTime = 0;

var apiURL = 'http://localhost:3000';

// player textbox name
var playerName = '';

var playingTime = 0;

var playAgainBtn = null;

let randomElementCoord = {};

let randomElementCoordinates = [];

let collectedBoxes = 0;

let maxBoxes = 2;

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

  randomTexture = gl.createTexture();
  randomTexture.image = new Image();
  randomTexture.image.onload = () => handleTextureLoaded(randomTexture);
  randomTexture.image.src = "./images/crate.gif";
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

function saveDataToDB(name, time) {
  var request = new XMLHttpRequest();

  request.open("POST", `${apiURL}/statistic`);
  request.setRequestHeader("Content-Type", "application/json");
  request.onreadystatechange = function() {
    if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
      console.log("Succesfully saved data");
    }
  }

  let data = {
    "playerName": name,
    "time": time,
    "date": new Date()
  };

  request.send(JSON.stringify(data));
}

function drawScene() {

  // set the rendering environment to full canvas size
  gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
  // Clear the canvas before we start drawing on it.
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

  // If buffers are empty we stop loading the application.
  if (worldVertexTextureCoordBuffer == null || worldVertexPositionBuffer == null || elementVertexPositionBuffer == null) {
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

  // update current position so player can see it
  document.getElementById('x').textContent = xPosition;
  document.getElementById('y').textContent = yPosition;
  document.getElementById('z').textContent = zPosition;

  var timeNow = new Date().getTime();
  if (lastTime != 0) {
    var elapsed = timeNow - lastTime;

    if (speed != 0) {

      let xPositionOld = xPosition;
      let yPositionOld = yPosition;

      xPosition -= Math.sin(degToRad(yaw)) * speed * elapsed;
      yPosition -= Math.cos(degToRad(yaw)) * speed * elapsed;
      joggingAngle += elapsed * 0.6;

      // cannot go outside of maze boundaries
      if(xPosition >= 12.2 || xPosition <= -12.2) {
        xPosition = xPositionOld;
      }

      if(yPosition >= 12.2 || yPosition <= -12.2) {
        yPosition = yPositionOld;
      }

      if(detectCollision(xPosition, yPosition)) {
        playWallHitMusic();
        xPosition = xPositionOld;
        yPosition = yPositionOld;
      }

      // for 'jogging' effect when moving
      if (stevec == 0) { 
        zPosition = Math.sin(degToRad(joggingAngle)) / 20 + 0.4;
      }
    }

    yaw += yawRate * elapsed;
    pitch += pitchRate * elapsed;

  }

  lastTime = timeNow;
}

function handleKeyDown(event) {

  /*  
  used keyCodes
    32 - space
    38 - up arrow
    40 - down arrow
    65 - a
    67 - c
    68 - d
    83 - s
    87 - w 
  */

  currentlyPressedKeys[event.keyCode] = true;
}

function handleKeyUp(event) {
  // reseting the pressed state for individual key
  currentlyPressedKeys[event.keyCode] = false;

  // space was pressed
  if (event.keyCode == 32) {

    // to prevent from staying in the air when jumping
    if (stevec != 0) { 
      zPosition = 0.4;
    }
    
    stevec = 0;
    skok = false;
  }
}

function handleKeys() {

  // 'up arrow' was pressed
  if (currentlyPressedKeys[38]) {
    pitchRate = 0.1;
  } 
  // 'down arrow' was pressed
  else if (currentlyPressedKeys[40]) {
    pitchRate = -0.1;
  } 
  // else is needed to stop rotation, othwerise we just rotate forever in circle
  else {
    pitchRate = 0;
  }

  // 'a' was pressed
  if (currentlyPressedKeys[65]) {
    yawRate = 0.1;
  } 
  // 'd' was pressed
  else if (currentlyPressedKeys[68]) {
    yawRate = -0.1;
  } 
  // else is needed to stop rotation, othwerise we just rotate forever in circle
  else {
    yawRate = 0;
  }

  // 'w' was pressed
  if (currentlyPressedKeys[87]) {
    speed = 0.003;
  } 
  // 's' was pressed
  else if (currentlyPressedKeys[83]) {
    speed = -0.003;
  } 
  // else is needed to stop movement, otherwise we would float into space
  else {
    speed = 0;
  }

  // space was pressed
  if (currentlyPressedKeys[32]) { 
    stevec++;
    if (stevec < 10) {
      zPosition += 0.04;
    }
    if (stevec > 10) {
      if (zPosition - 0.04 > 0.4)
        zPosition -= 0.04;

    }
    skok = true;

  }

  // c was pressed
  if (currentlyPressedKeys[67]) { 
    zPosition = 0.21;
  }
}

function updateTimer(time) {
  document.getElementsByClassName("elapsedTime")[0].innerHTML = time;
}

/* Just for testing purposes */ 
function moveToRandom() {
  xPosition = randomElementCoordinates[0].x - 0.5;
  yPosition = randomElementCoordinates[0].y - 0.5;
}

function resetGame() {
  konec = true;
  start = false;
  updateTimer(playingTime);
  // show play again button
  playAgainBtn = document.getElementById("btnPlayAgain");
  playAgainBtn.style.display = 'inline-block';
  // show player div
  document.getElementsByClassName("playerData")[0].style.display = 'block';
}

function playAgain() {
  xPosition = 0;
  yPosition = 0;
  playingTime = 0;
  playBackgroundMusic();
  collectedBoxes = 0;
  document.getElementsByClassName("collectedBoxes")[0].innerHTML = `Collected boxes: ${collectedBoxes}`;
  konec = false;
  start = true;
  randomElementCoordinates = [];
  initBuffersRandomElement({size: maxBoxes, e: 0.3});
  playAgainBtn = document.getElementById("btnPlayAgain");
  playAgainBtn.style.display = 'none';
  // hide playerData div
  document.getElementsByClassName("playerData")[0].style.display = 'none';

  // start updating scene rendering
  vmes();
}

function checkBoxesCollection() {
  for (let i = 0; i < randomElementCoordinates.length; i++) {
    let element = randomElementCoordinates[i];
    if (detectBox(element) && !element.detected) {
      playCollectBoxMusic();
      randomElementCoordinates[i].detected = true;
      collectedBoxes++;
      document.getElementsByClassName("collectedBoxes")[0].innerHTML = `Collected boxes: ${collectedBoxes}`;

      // set randomElement coordinates to latest 
      randomElementCoordinates = randomElementCoordinates.filter(box => !box.detected);
      updateRandomElementsBuffers(randomElementCoordinates);
    }
  }
}

function vmes() {

  let gameInterval = setInterval(function () {
    if (texturesLoaded) { // only draw scene and animate when textures are loaded.

      if (stevec > 20) { // za skok
        stevec = 0;
      }

      if (!konec && start) { //dokler ni konec igre lahko opravlamo
        playBackgroundMusic();
        requestAnimationFrame(animate);
        handleKeys();
      }
     
      drawScene(); // najprej narisemo svet, potem pa razlicne objetke
      drawFloor();
      checkBoxesCollection();
      
      
      // {x:0, y:-2, e: 0.3} randomElementCoord
      if(maxBoxes == collectedBoxes) {
        saveDataToDB(playerName, playingTime);
        playEndGameMusic();
        resetGame();
        clearInterval(gameInterval);
      }
    }
  }, 15);

  gameInterval;

}

function updatePlayingTime() {
  setInterval(() => {
    if (!konec && start) {
      playingTime++;
      updateTimer(playingTime);
    }
  }, 1000);
}

function savePlayer() {
  var textBoxPlayerName = document.getElementById("txtPlayerName");

  if (!textBoxPlayerName.value.length > 0) {
    alert("Player length must not be null");
  } else {
    playerName = textBoxPlayerName.value;
    start = true;
    // show timer
    document.getElementsByClassName("elapsedTime")[0].style.display = 'block';

    // hide main div for player information
    document.getElementsByClassName("playerData")[0].style.display = 'none';
  }
}

function startGame() {
  canvas = document.getElementById("canvas");
  document.getElementsByClassName("totalBoxes")[0].innerHTML = `Total boxes: ${maxBoxes}`;
  document.getElementsByClassName("collectedBoxes")[0].innerHTML = `Collected boxes: ${collectedBoxes}`;

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
    initBuffersFloor();
    initBuffersWalls();

    initBuffersRandomElement({size: maxBoxes, e: 0.3});
    

    // keyboard bindings
    document.onkeydown = handleKeyDown;
    document.onkeyup = handleKeyUp;

    drawScene();
    drawFloor();
      
    vmes();
    updatePlayingTime();
  }
}