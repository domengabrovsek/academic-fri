'use strict';

class Vector4f {

    // constructor
    constructor(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    };

    // methods

    // negate input vector
    static negate(vector) {
        // check if input is of correct type and length
        if(!(vector instanceof Vector4f && Object.keys(vector).length === 3)) {
            return new Error('Vhod mora biti tipa Vector4f in more vsebovati koordinate x,y in z.')
        }

        // multiply every coordinate by -1 to negate the vector
        return new Vector4f(...Object.values(vector).map(x => x * -1));
    };

    // add two vectors
    static add(vector1, vector2) {

        // there should be only two vectors in input, both of same type and length
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 3) && Object.values(arguments).length === 2)) {
            return;
        }

        // sum all elements at same indexes in both arrays
        return new Vector4f(...Object.values(vector1).map((n, i) => n + Object.values(vector2)[i]));
    };

    // scalar product (scalar * vector)
    static scalarProduct(scalar, vector) {
        
        if(typeof(scalar) !== 'number') {
            return;
        }

        if(!(vector instanceof Vector4f && Object.keys(vector).length === 3)) {
            return;
        }

        return new Vector4f(...Object.values(vector).map(value => value * scalar));

    };

    // dot product (vector * vector)
    static dotProduct(vector1, vector2) {
        // there should be only two vectors in input, both of same type and length
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 3) && Object.values(arguments).length === 2)) {
            return;
        }

        // multiply elements at same index and sum them up
        return Object.values(vector1).map((n, i) => n * Object.values(vector2)[i]).reduce((sum, value) => sum + value, 0);

    };

    static crossProduct(vector1, vector2) {
        // there should be only two vectors in input, both of same type and length
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 3) && Object.values(arguments).length === 2)) {
            return;
        }

        const x = vector1.y * vector2.z - vector1.z * vector2.y;
        const y = vector1.z * vector2.x - vector1.x * vector2.z;
        const z = vector1.x * vector2.y - vector1.y * vector2.x;

        return new Vector4f(x, y, z);

    };

    // second norm -> square root of sum of all elements to the second power 
    static length(vector) {
        if(!(vector instanceof Vector4f) && Object.keys(vector).length === 3) {
            return;
        }

        return Math.sqrt(Object.values(vector).reduce((length, value) => length + Math.pow(value, 2), 0));
    };

    // unit vector -> vector divided by its length
    static normalize(vector) {
        if(!(vector instanceof Vector4f) && Object.keys(vector).length === 3) {
            return;
        }

        // we cannot normalize vector with length 0 because division with 0 is not defined
        if(this.length(vector) <= 0) {
            return;
        }

        return new Vector4f(...Object.values(vector).map(value => value /= this.length(vector)));
    };

    // scalar product (dot product(vector1, vector2) / vector1.length^2, vector1)
    static project(vector1, vector2) {
        // there should be only two vectors in input, both of same type and length
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 3) && Object.values(arguments).length === 2)) {
            return;
        }

        const dotProduct = this.dotProduct(vector1, vector2);
        const firstLength = this.length(vector1);

        if(firstLength <= 0) {
            return;
        }

        const scalarProduct = this.scalarProduct(dotProduct / Math.pow(firstLength, 2), vector1);

        return scalarProduct;
        
    };

    // vector lengths multiplied by cos phi is equal to dot product of vectors
    static cosPhi(vector1, vector2) {
        // there should be only two vectors in input, both of same type and length
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 3) && Object.values(arguments).length === 2)) {
            return;
        }

        const dotProduct = this.dotProduct(vector1, vector2);
        const firstLength = this.length(vector1);
        const secondLength = this.length(vector2);

        // division by zero protecion, if any of those is 0 then cos phi is 0
        if([dotProduct, firstLength, secondLength].includes(0)) {
            return 0;
        }

        // dot product = vector1.length * vector2.length * cos phi
        return dotProduct / firstLength / secondLength;

    };
}

class Matrix4f {

    constructor(matrix) {
        this.matrix = matrix;
    }

    static negate(matrix) {

        if(!(matrix instanceof Matrix4f) && Object.keys(matrix).length === 4) {
            return;
        }

        return new Matrix4f(matrix.matrix.map(row => row.map(value => value * -1)));

    }

    static add(matrix1, matrix2) {

        // there should be only two matrices in input, both of same type and length
        if(!(Object.values(arguments).every(matrix => matrix instanceof Matrix4f && Object.keys(matrix.matrix).length === 4) && Object.values(arguments).length === 2)) {
            return;
        }

        // sum all elements at same indexes in both arrays
        return new Matrix4f((Object.values(matrix1.matrix).map((row, i) => row.map((value, j) => value + matrix2.matrix[i][j]))));
    };

    static transpose(matrix) {
        if(!(matrix instanceof Matrix4f) && Object.keys(matrix).length === 4) {
            return;
        }

        return new Matrix4f(matrix.matrix[0].map((column, i) => matrix.matrix.map(row => row[i])));
    }

    static multiplyScalar(scalar, matrix) {
        if(typeof(scalar) !== 'number') {
            return;
        }

        if(!(matrix instanceof Matrix4f && Object.keys(matrix.matrix).length === 4)) {
            return;
        }

        return new Matrix4f(matrix.matrix.map(row => row.map(value => value * scalar)));
    }

    static multiply(matrix1, matrix2) {

        // number of rows in first matrix has to match number of columns in the second matrix, we are using 4x4 matrices here
        if(!(matrix1.matrix.length === 4 && matrix1.matrix.every(row => row.length === 4) && matrix2.matrix.every(row => row.length === 4))) {
            return;
        }

        // multiply values in same indexes and add them together
        const multiplyAndAdd = (a, b) => a && b && a.map((value, i) => value * b[i]).reduce((sum, tmp) => sum + tmp, 0); 

        // number of rows in first matrix
        const rows = matrix1.matrix.length;

        // number of columns in second matrix
        const columns = matrix2.matrix[0].length;

        let newMatrix = [];

        for(let i = 0; i < rows; i++) {
            // if array doesn't exist yet
            if(!newMatrix[i]) {
                newMatrix[i] = [];
            }

            for(let j = 0; j < columns; j++) {
                // multiply row from first matrix with column from second matrix and add it up
                newMatrix[i][j] = multiplyAndAdd(matrix1.matrix[i], this.transpose(matrix2).matrix[j]);
            }
        }

        return new Matrix4f(newMatrix);
    }
}

const matrix1 = new Matrix4f([
    [1, 2, 3, 4],
    [4, 3, 2, 1],
    [5, 6, 7, 8],
    [8, 7, 6, 5]
]);

const matrix2 = new Matrix4f([
    [1, 2, 4, 8],
    [8, 4, 2, 1],
    [1, 3, 5, 7],
    [7, 5, 3, 1]
]);

const scalar = 2;

// helpers

const outMatrix = matrix => matrix && Object.values(matrix).forEach(row => console.table(row));

console.log('Matrix 1:')
outMatrix(matrix1);

console.log('Matrix 2:')
outMatrix(matrix2);

console.log('Negate Matrix 1: ');
outMatrix(Matrix4f.negate(matrix1));

console.log('Add Matrix 1,2: ');
outMatrix(Matrix4f.add(matrix1, matrix2));

console.log('Transpose Matrix 1: ');
outMatrix(Matrix4f.transpose(matrix1));

console.log('Multiply Matrix 1 with scalar(2): ')
outMatrix(Matrix4f.multiplyScalar(scalar, matrix1));

console.log('Multiply Matrix 1 with Matrix 2: ')
outMatrix(Matrix4f.multiply(matrix1, matrix2));

// const vector1 = new Vector4f(1, 2, 3);
// const vector2 = new Vector4f(3, 2, 1);

// console.log('Vektor 1: ', vector1);
// console.log('Vektor 2: ', vector2);

// console.log('Negate: ', Vector4f.negate(vector1));
// console.log('Add: ', Vector4f.add(vector1, vector2));
// console.log('Scalar product: ', Vector4f.scalarProduct(5, vector1));
// console.log('Dot product: ', Vector4f.dotProduct(vector1, vector2));
// console.log('Cross product: ', Vector4f.crossProduct(vector1, vector2));
// console.log('Length: ', Vector4f.length(vector1));
// console.log('Normalize: ', Vector4f.normalize(vector1));
// console.log('Project: ', Vector4f.project(vector1, vector2));
// console.log('Cos phi: ', Vector4f.cosPhi(vector1, vector2));