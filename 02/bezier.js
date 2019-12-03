'use strict';

let circles = []; // array of drawn points

let lines = []; // array of drawn lines

let canvas, context;

let drawing = true;
let dragOk = false;

// variable for line drawing
let lastPoint;


// variables to save starting mouse position before dragging
let startMouseX, startMouseY;

// function to draw initial coordinate system grid
function drawGrid(width, height) {

  context.strokeStyle = "blue"; // grid color

  const squareSize = 10;
  context.lineWidth = 0.3;

  // for (let i = 0; i <= width; i += squareSize) {
  //   context.moveTo(0.5 + i, 0)
  //   context.lineTo(0.5 + i, height)
  // }

  // for (let i = 0; i <= height; i += squareSize) {
  //   context.moveTo(0, 0.5 + i);
  //   context.lineTo(width, 0.5 + i);
  // }

  // context.stroke();

  // draw black border around canvas
  context.lineWidth = 1;
  context.strokeStyle = "red";
  context.strokeRect(0, 0, canvas.width, canvas.height);
}

function init() {
  canvas = document.getElementById('BezierCanvas');
  context = canvas.getContext('2d')

  // draw coordinate system like grid
  drawGrid(canvas.width, canvas.height);

  // draw all elements in object array
  draw();

  // mousemove
  canvas.addEventListener('mousemove', e => {

    // save current mouse position
    let mouseX = e.clientX;
    let mouseY = e.clientY;

    // output current mouse x,y to screen
    document.getElementById('x').textContent = mouseX;
    document.getElementById('y').textContent = mouseY;

    // change cursor type and disable drawing if mouse is inside circle
    if(circles.some(circle => isInCircle(circle, mouseX, mouseY))) {
      drawing = false;
      document.body.style.cursor = 'pointer';
    } else {
      drawing = true;
      document.body.style.cursor = 'default';
    }

    // if dragging an object
    if(dragOk) {
    
      // mouse distance from start to end
      let mouseDistanceX = mouseX - startMouseX;
      let mouseDistanceY = mouseY - startMouseY;

      // move circles to new location
      for(let circle of circles) {
        if(circle.isDragging) {
          circle.x += mouseDistanceX;
          circle.y += mouseDistanceY;
        }
      }

      // redraw the whole canvas
      draw();

      // save mouse position for next move
      startMouseX = mouseX;
      startMouseY = mouseY;
    }
  })

  // mousedown
  canvas.addEventListener('mousedown', e => {

    // save current mouse position
    let mouseX = e.clientX;
    let mouseY = e.clientY;

    dragOk = false;

    for(let circle of circles) {
      if(isInCircle(circle, mouseX, mouseY)) {
        dragOk = true;
        circle.isDragging = true;
      }
    }

    startMouseX = mouseX;
    startMouseY = mouseY;

    // add new circle to object array (redraw on mouseup)
    if(drawing) {
      circles.push({ x: e.clientX, y: e.clientY, size: 5, fillColor: 'white', borderColor: 'red' })

      const endPoint = {
        x: circles[circles.length - 1].x - 10,
        y: circles[circles.length - 1].y - 10
      };

      
      if(circles.length > 1) {
        const startPoint = {
          x: circles[circles.length - 2].x - 10,
          y: circles[circles.length - 2].y - 10
        }

        lines.push({ a: startPoint, b: endPoint });

      }
    }
  });

  // mouseup
  canvas.addEventListener('mouseup', e => {

    dragOk = false;

    // disable dragging on all circles
    circles.forEach(circle => circle.isDragging = false);

    // redraw everything
    draw();
  });

  // double click (clear everything, used for testing purposes)
  canvas.addEventListener('dblclick', e => {
    // clear canvas
    clear();

    // remove all saved objects
    circles = [];
    lines = [];

    // update number of points currently drawn
    document.getElementById("numberOfPoints").textContent = circles.length;
  }); 
}

function isInCircle(circle, x, y) {

  const isInCircle = circle && !(circle.x - circle.size >= x || 
    circle.x + circle.size <= x || 
    circle.y - circle.size >= y || 
    circle.y + circle.size <= y);

  return isInCircle;
}

function clear() {

  // clear whole canvas
  context.clearRect(0, 0, canvas.width, canvas.height);

  // use default comp. mode
  context.globalCompositeOperation = "source-over";

  // reset alpha
  context.globalAlpha = 1;

  context.fillStyle = "rgba(255, 255, 255, 1)";

  // redraw the grid
  drawGrid(canvas.width, canvas.height);
}

function draw() {
  clear();

  for(let line of lines) {
    drawLine(line)
  }

  for (let circle of circles) {
    drawCircle(circle);
  }

  // update number of points currently drawn
  document.getElementById("numberOfPoints").textContent = circles.length;
}

function drawSquare(properties) {
  const {
    x,
    y,
    size,
    fillColor,
    borderColor
  } = properties;
  context.fillStyle = fillColor;
  context.strokeStyle = borderColor;
  context.rect(x - 10, y - 10, size, size);
  context.closePath();
  context.fill();
}

function drawCircle(properties) {
  const { x, y, size, fillColor, borderColor } = properties;
  context.fillStyle = fillColor;
  context.strokeStyle = borderColor;
  context.lineWidth = 1;
  context.beginPath();
  context.arc(x - 10, y - 10, size, 0, 2 * Math.PI, false);
  context.fill();
  context.stroke();
}

function drawLine(line) {

  const { a, b } = line;

  context.beginPath();
  context.moveTo(a.x, a.y);
  context.lineTo(b.x, b.y);
  context.strokeStyle = 'black';
  context.stroke()
}

function bezier(t, p0, p1, p2, p3) {
  var cX = 3 * (p1.x - p0.x),
    bX = 3 * (p2.x - p1.x) - cX,
    aX = p3.x - p0.x - cX - bX;

  var cY = 3 * (p1.y - p0.y),
    bY = 3 * (p2.y - p1.y) - cY,
    aY = p3.y - p0.y - cY - bY;

  var x = (aX * Math.pow(t, 3)) + (bX * Math.pow(t, 2)) + (cX * t) + p0.x;
  var y = (aY * Math.pow(t, 3)) + (bY * Math.pow(t, 2)) + (cY * t) + p0.y;

  return {
    x: x,
    y: y
  };
}