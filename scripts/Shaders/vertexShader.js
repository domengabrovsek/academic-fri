const vertexSourceCode = `#version 300 es
attribute vec3 aVertexPosition;
attribute vec2 aTextureCoord;

uniform mat4 uMVMatrix;
uniform mat4 uProjectMatrix;

out vec2 vTexCoord;

void main() {
    vTextureCoord = aTextureCoord;
    gl_Position = uProjectMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
}
`;

const attribute_name_vertexPosition = "aVertexPosition";
const attribute_name_vertexColor = "aVertexColor";
const attribute_name_textureCoord = "aTextureCoord";
const uniform_name_mvMatrix = "uMVMatrix";
const uniform_name_pMatrix = "uProjectMatrix";

export {
    vertexSourceCode,
    attribute_name_vertexPosition,
    attribute_name_vertexColor,
    attribute_name_textureCoord,
    uniform_name_mvMatrix,
    uniform_name_pMatrix
};