'use strict';

const input = document.getElementById('input');    
const output = document.getElementById('output');    

// output to second text area when user inputs something
input.addEventListener('input', () => {
    output.value = PointManager.ReadPoints(input.value).map(x => TransformPoints.Transform(x)).join('\n');
});