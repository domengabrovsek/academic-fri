'use strict';

class Transformation {
    constructor() {
        this.matrix = new Matrix4f();

        // create identity matrix
        this.matrix.matrix.forEach((row, index) => row.forEach(y => row[index] = 1)); 
    }

    translate(vector) {
        // prepare translation matrix
        const translationMatrix = new Transformation().matrix;
        
        translationMatrix.matrix[0][3] = vector.x;
        translationMatrix.matrix[1][3] = vector.y;
        translationMatrix.matrix[2][3] = vector.z;
        translationMatrix.matrix[3][3] = 1;

        this.matrix = Matrix4f.multiply(translationMatrix, this.matrix);
    }

    scale(vector) {
        // prepare scalation matrix
        const scalationMatrix = new Transformation().matrix;

        scalationMatrix.matrix[0][0] = vector.x;
        scalationMatrix.matrix[1][1] = vector.y;
        scalationMatrix.matrix[2][2] = vector.z;
        scalationMatrix.matrix[3][3] = 1;

        this.matrix = Matrix4f.multiply(scalationMatrix, this.matrix);
    }

    rotateX(angle) {
        // prepare rotation matrix
        const rotationMatrix = new Transformation().matrix;

        rotationMatrix.matrix[1][1] = Math.cos(angle);
        rotationMatrix.matrix[1][2] = Math.sin(angle) * -1;
        rotationMatrix.matrix[2][1] = Math.sin(angle);
        rotationMatrix.matrix[2][2] = Math.cos(angle);

        this.matrix = Matrix4f.multiply(rotationMatrix, this.matrix);
    }

    rotateY(angle) {
        // prepare rotation matrix
        const rotationMatrix = new Transformation().matrix;

        rotationMatrix.matrix[0][0] = Math.cos(angle);
        rotationMatrix.matrix[0][2] = Math.sin(angle);
        rotationMatrix.matrix[2][0] = Math.sin(angle) * -1;
        rotationMatrix.matrix[2][2] = Math.cos(angle);

        this.matrix = Matrix4f.multiply(rotationMatrix, this.matrix);
    }

    rotateZ(angle) {
        // prepare rotation matrix
        const rotationMatrix = new Transformation().matrix;

        rotationMatrix.matrix[0][0] = Math.cos(angle);
        rotationMatrix.matrix[0][1] = Math.sin(angle) * -1;
        rotationMatrix.matrix[1][0] = Math.sin(angle);
        rotationMatrix.matrix[1][1] = Math.cos(angle);

        this.matrix = Matrix4f.multiply(rotationMatrix, this.matrix);
    }

    static transformPoint(point) {

        // helper to output matrix to check states between transformations
        const outMatrix = matrix => matrix && Object.values(matrix).forEach(row => console.table(row));

        // start with identity matrix
        const startingMatrix = new Transformation(); 
        outMatrix(startingMatrix.matrix);

        // translate over x axis for 1.25
        startingMatrix.translate(new Vector4f(1.25, 0, 0));
        outMatrix(startingMatrix.matrix);

        // rotate around z axis for angle pi/3
        startingMatrix.rotateZ(Math.PI / 3);
        outMatrix(startingMatrix.matrix);

        // translate over z axis for 4.15
        startingMatrix.translate(new Vector4f(0, 0, 4.15));
        outMatrix(startingMatrix.matrix);

        // translate over y axis for 3.14
        startingMatrix.translate(new Vector4f(0, 3.14, 0));
        outMatrix(startingMatrix.matrix);
        
        // scale over x and y axis for 1.12
        startingMatrix.scale(new Vector4f(1.12, 1.12, 1));
        outMatrix(startingMatrix.matrix);

        // rotate around y axis for 5*pi/8
        startingMatrix.rotateY(5 * (Math.PI / 8));
        outMatrix(startingMatrix.matrix);

        // transform point to Matrix4f structure
        const pointAsMatrix = new Array();
        pointAsMatrix[0] = new Array();
        pointAsMatrix[1] = new Array();
        pointAsMatrix[2] = new Array();
        pointAsMatrix[3] = new Array();

        pointAsMatrix[0][0] = point.x
        pointAsMatrix[1][0] = point.y
        pointAsMatrix[2][0] = point.z
        pointAsMatrix[3][0] = 1;

        return Matrix4f.multiply(startingMatrix.matrix, new Matrix4f(pointAsMatrix));
    }}

// helpers to check output
const point = new Vector4f(1, 2, 3);
console.log(`Original point: x:${point.x}, y:${point.y}, z:${point.z}`);

const transformedPoint = Transformation.transformPoint(point).matrix;
console.log(`Transformed point: x:${transformedPoint[0][0]}, y:${transformedPoint[1][0]}, z:${transformedPoint[2][0]}`);