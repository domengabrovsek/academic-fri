
let vertexShaderString = `
  // atributes for setting vertex position and texture coordinates
  attribute vec3 aVertexPosition;
  attribute vec2 aTextureCoord;

  uniform mat4 uMVMatrix;	// model-view matrix
  uniform mat4 uPMatrix;	// projection matrix

  // variable for passing texture coordinates
  // from vertex shader to fragment shader
  varying vec2 vTextureCoord;

  void main(void) {
    // calculate the vertex position
    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    vTextureCoord = aTextureCoord;
`;

let fragmentShaderString = `
  precision mediump float;

  // uniform attribute for setting texture coordinates
  varying vec2 vTextureCoord;

  // uniform attribute for setting 2D sampler
  uniform sampler2D uSampler;

  void main(void) {
    // sample the fragment color from texture
    gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
  }
`;