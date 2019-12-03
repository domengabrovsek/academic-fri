'use strict';

class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }
}

/* -------------------------------------------------------------------- */

function drawGrid (context, width, height) {

    const squareSize = 6;
    context.lineWidth = 0.3;

    for(let i = 0; i <= width; i += squareSize) {
        context.moveTo(0.5 + i, 0)
        context.lineTo(0.5 + i, height)
    }

    for(let i = 0; i <= height; i += squareSize) {
        context.moveTo(0, 0.5 + i);
        context.lineTo(width, 0.5 + i);
    }

    context.strokeStyle = "gray";
    context.stroke();
}

function init () {
    const canvas = document.getElementById('BezierCanvas');
    const context = canvas.getContext('2d')
    let drawing = false;

    drawGrid(context, canvas.width, canvas.height);

    context.lineWidth = 1;
    context.strokeStyle = "#000000'";
    context.strokeRect(0, 0, canvas.width, canvas.height);

    // event listeners

    // mousemove
    canvas.addEventListener('mousemove', e => {
        document.getElementById('x').textContent = `x: ${e.clientX}`;
        document.getElementById('y').textContent = `y: ${e.clientY}`;
    })

    // mousedown
    canvas.addEventListener('mousedown', e => {
        // context.beginPath();
        // context.moveTo(e.clientX, e.clientY);
        // console.log(`Starting point: x:${e.clientX}, y:${e.clientY}`);
    });

    // mouseup
    canvas.addEventListener('mouseup', e => {
        // context.lineTo(e.clientX, e.clientY);
        // context.stroke();
        // console.log(`Ending point: x:${e.clientX}, y:${e.clientY}`);
    });

    canvas.addEventListener('click', e => {
        drawCircle({ context, x: e.clientX, y: e.clientY, size: 3, fillColor: 'orange', borderColor: 'black'});
        // drawSquare({ context, x: e.clientX + 50, y: e.clientY + 50, size: 8, fillColor: 'black', borderColor: 'black' });
    });
}

function drawSquare(properties) {
    const { x, y, size, fillColor, borderColor, context } = properties;
    context.fillStyle = fillColor;
    context.strokeStyle = borderColor;
    context.fillRect(x -10, y - 10, size, size);
}

function drawCircle(properties) {
    const { x, y, size, fillColor, borderColor, context } = properties;
    context.beginPath();
    context.arc(x - 10, y - 10, size, 0, 2 * Math.PI, false);
    context.fillStyle = fillColor;
    context.fill();
    context.lineWidth = 1;
    context.strokeStyle = borderColor;
    context.stroke();
}

function bezier(t, p0, p1, p2, p3){
    var cX = 3 * (p1.x - p0.x),
        bX = 3 * (p2.x - p1.x) - cX,
        aX = p3.x - p0.x - cX - bX;
  
    var cY = 3 * (p1.y - p0.y),
        bY = 3 * (p2.y - p1.y) - cY,
        aY = p3.y - p0.y - cY - bY;
  
    var x = (aX * Math.pow(t, 3)) + (bX * Math.pow(t, 2)) + (cX * t) + p0.x;
    var y = (aY * Math.pow(t, 3)) + (bY * Math.pow(t, 2)) + (cY * t) + p0.y;
  
    return {x: x, y: y};
  }