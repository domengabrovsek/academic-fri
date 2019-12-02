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
        context.beginPath();
        context.moveTo(e.clientX, e.clientY);
        console.log(`Starting point: x:${e.clientX}, y:${e.clientY}`);
    });

    // mouseup
    canvas.addEventListener('mouseup', e => {
        context.lineTo(e.clientX, e.clientY);
        context.stroke();
        console.log(`Ending point: x:${e.clientX}, y:${e.clientY}`);
    });
}