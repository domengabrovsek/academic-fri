'use strict';

let points = []; // array of drawn points
let lines = []; // array of drawn lines

let canvas, context, colorPicker, curveColor;
let numberOfCurves = 0

let drawing = true;
let dragOk = false;

// variables to save starting mouse position before dragging
let startMouseX, startMouseY;

// function to draw initial coordinate system grid
function drawGrid(width, height) {

  context.strokeStyle = "gray"; // grid color

  const squareSize = 10;
  context.lineWidth = 0.3;

  for (let i = 0; i <= width; i += squareSize) {
    context.moveTo(0.5 + i, 0)
    context.lineTo(0.5 + i, height)
  }

  for (let i = 0; i <= height; i += squareSize) {
    context.moveTo(0, 0.5 + i);
    context.lineTo(width, 0.5 + i);
  }

  context.stroke();

  // draw black border around canvas
  context.lineWidth = 1;
  context.strokeStyle = "black";
  context.strokeRect(0, 0, canvas.width, canvas.height);
}

// initialize canvas with all its event handlers
function init() {
  colorPicker = document.getElementById('curveColor');
  curveColor = colorPicker.value;

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

    // change cursor type and disable drawing if mouse is inside point
    if(points.some(point => isInpoint(point, mouseX, mouseY))) {
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

      // move points to new location
      for(let point of points) {
        if(point.isDragging) {
          point.x += mouseDistanceX;
          point.y += mouseDistanceY;
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

    for(let point of points) {
      if(isInpoint(point, mouseX, mouseY)) {
        dragOk = true;
        point.isDragging = true;
      }
    }

    // save mouse position for next move
    startMouseX = mouseX;
    startMouseY = mouseY;

    // if we're allowed to draw (mouse not on existing object)
    if(drawing) {

      // add new point to object array (redraw on mouseup)
      points.push({ x: e.clientX, y: e.clientY, size: 5, fillColor: 'white', borderColor: 'red', number: points.length + 1 });
    }
  });

  // mouseup
  canvas.addEventListener('mouseup', e => {  
    dragOk = false;

    // disable dragging on all points
    points.forEach(point => point.isDragging = false);

    // redraw everything
    draw();
  });

  // double click (clear everything, used for testing purposes)
  canvas.addEventListener('dblclick', e => {
    // clear canvas
    clear();

    // remove all saved objects
    points = [];
    lines = [];
    numberOfCurves = 0;

    // update number of points currently drawn
    document.getElementById("numberOfPoints").textContent = points.length;

    // update number of curves currently drawn
    document.getElementById("numberOfCurves").textContent = 3;

  }); 

  // update color
  colorPicker.addEventListener('input', e => {

    console.log(`Curve color changed from: ${curveColor} to ${e.target.value}`);
    curveColor = e.target.value;

    // redraw to update color of curve
    draw();
    
  });
}

/* -------------- helper functions -------------- */

// returns true if given point is inside given point on canvas
function isInpoint(point, x, y) {

  const isInpoint = point && !(point.x - point.size >= x || 
    point.x + point.size <= x || 
    point.y - point.size >= y || 
    point.y + point.size <= y);

  return isInpoint;
}

function clear() {

  // clear whole canvas
  context.clearRect(0, 0, canvas.width, canvas.height);

  // redraw the grid
  drawGrid(canvas.width, canvas.height);
}

// clear canvas and redraw all saved objects
function draw() {
  clear();

  // draw lines
  if(points.length > 1) {
    for(let i = 0; i < points.length - 1; i++) {
      const startPoint = { x: points[i].x - 10, y: points[i].y - 10};
      const endPoint = { x: points[i + 1].x - 10, y: points[i + 1].y - 10};

      drawLine(startPoint, endPoint);
    }
  }
    
  // draw bezier curves, need at least 4 points for first one and then 3 for next ones
  if(points.length >= 4 && (points.length - 4) % 3 === 0) {

    // need to reset counter everytime otherwise it increments it in every iteration
    numberOfCurves = 0;

    /* pattern for picking points to draw:
      curve 1:  0 1 2 3
      curve 2:  3 4 5 6
      curve 3:  6 7 8 9
      curve 4:  9 10 11 12 
    */

    for(let i = 0; i < points.length - 1; i += 3) {
    
      let p0 = points[i];
      let p1 = points[i + 1];
      let p2 = points[i + 2];
      let p3 = points[i + 3];

      // - 10 is used to move point to the pointing point of cursor
      let pointsToDraw = [p0, p1, p2, p3].map(p => ({ x: p.x - 10, y: p.y - 10 }));

      drawBezierCurve(pointsToDraw[0], pointsToDraw[1], pointsToDraw[2], pointsToDraw[3]);
      numberOfCurves += 1;
    }
  }

  // draw lines again (this is a hack because last line was always same color as curve if this isn't called)
  if(points.length > 1) {
    for(let i = 0; i < points.length - 1; i++) {

      // - 10 is used to move point to the pointing point of cursor
      const startPoint = { x: points[i].x - 10, y: points[i].y - 10};
      const endPoint = { x: points[i + 1].x - 10, y: points[i + 1].y - 10};

      drawLine(startPoint, endPoint);
    }
  }


  // draw points
  for (let point of points) {
    drawpoint(point);
  }

  // update number of points currently drawn
  document.getElementById("numberOfPoints").textContent = points.length;

  // update number of curves currently drawn
  document.getElementById("numberOfCurves").textContent = numberOfCurves;
}

function drawSquare(properties) {
  const { x, y, size, fillColor, borderColor } = properties;
  context.fillStyle = fillColor;
  context.strokeStyle = borderColor;
  context.rect(x - 10, y - 10, size, size);
  context.closePath();
  context.fill();
}

function drawpoint(properties) {
  const { x, y, size, fillColor, borderColor, number } = properties;
  context.fillStyle = fillColor;
  context.strokeStyle = borderColor;
  context.lineWidth = 1;
  context.beginPath();
  context.arc(x - 10, y - 10, size, 0, 2 * Math.PI, false); // draw point
  context.fill();
  context.fillStyle = 'black'; // text color for point
  context.font = "bold 12pt Arial"; // font for point
  context.fillText(number, x - 25, y - 20); // add text to point
  context.stroke();
}

function drawLine(a, b) {
  context.beginPath();
  context.strokeStyle = 'black';
  context.moveTo(a.x, a.y);
  context.lineTo(b.x, b.y);
  context.stroke()
}

function drawBezierCurve(p0, p1, p2, p3) {

  // formula
  // P = (1−t)^3*P0 + 3(1−t)^2*t*P1 + 3(1−t)t^2*P2 + t^3*P3

  context.moveTo(p0.x, p0.y);

  for(let t = 0; t < 1; t+= 0.01) {
    // x = (1−t)^3*x0 + 3(1−t)^2*t*x1 + 3(1−t)t^2*x2 + t^3*x3
    let x = Math.pow(1 - t, 3) * p0.x + 
    Math.pow(1 - t, 2) * 3 * t * p1.x + 
    (1 - t) * 3 * t * t * p2.x + 
    Math.pow(t, 3) * p3.x;

    // y = (1−t)^3*y0 + 3(1−t)^2*t*y1 + 3(1−t)t^2*y2 + t^3*y3
    let y = Math.pow(1 - t, 3) * p0.y + 
    Math.pow(1 - t, 2) * 3 * t * p1.y + 
    (1 - t) * 3 * t * t * p2.y + 
    Math.pow(t, 3) * p3.y;

    context.lineTo(x, y);
  }

  context.strokeStyle = curveColor;
  context.stroke();
}