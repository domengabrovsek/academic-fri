'use strict';

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

// test helpers

const scalar = 2;

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