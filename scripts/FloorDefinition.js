
// each subarray in floor represents a triangle
let floorStartData = [
  generateTriangle({ aX: 3.5, aY: -0.5,bX: 3.5,bY: 10.0, cX: 10.0, cY: 10.0 }),
  generateTriangle({ aX: 10.0, aY: 10.0,bX: 10.0,bY: -0.5, cX: 3.5, cY: -0.5 })
];

let floor = 
[
  // maze floor
  generateTriangle({ aX: -13, aY: 13, bX: 13, bY: -13, cX: -13, cY: -13 }),
  generateTriangle({ aX: -13, aY: 13, bX: 13, bY:  13, cX:  13, cY: -13 }),

];