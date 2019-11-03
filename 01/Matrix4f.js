'use strict';

class Matrix4f {

    constructor(matrix) {
        // if no matrix is provided, create an empty 4x4 matrix
        if(!matrix) {
            matrix = new Array();
            matrix[0] = [0,0,0,0];
            matrix[1] = [0,0,0,0];
            matrix[2] = [0,0,0,0];
            matrix[3] = [0,0,0,0];
        }

        this.matrix = matrix;
    }

    static negate(matrix) {
        if(!matrix instanceof Matrix4f) {
            throw new Error('Provided matrix should be of type Matrix4f!');
        }

        return new Matrix4f(matrix.matrix.map(row => row.map(value => value * -1)));
    }

    static add(matrix1, matrix2) {
        if(!(Object.values(arguments).every(matrix => matrix instanceof Matrix4f) && Object.values(arguments).length === 2)) {
            throw new Error('There should be only two matrices in input, both of type Matrix4f!');
        }

        // sum all elements at same indexes in both arrays
        return new Matrix4f((Object.values(matrix1.matrix).map((row, i) => row.map((value, j) => value + matrix2.matrix[i][j]))));
    };

    static transpose(matrix) {
        if(!matrix instanceof Matrix4f) {
            throw new Error('Provided matrix should be of type Matrix4f!');
        }

        // transpose the matrix -> switch columns and rows
        return new Matrix4f(matrix.matrix[0].map((column, i) => matrix.matrix.map(row => row[i])));
    }

    static multiplyScalar(scalar, matrix) {
        if(typeof(scalar) !== 'number') {
            throw new Error('Provided scalar should be a number!');
        }

        if(!matrix instanceof Matrix4f) {
            throw new Error('Provided matrix should be of type Matrix4f!');
        }

        // multiply every value in matrix by provided scalar
        return new Matrix4f(matrix.matrix.map(row => row.map(value => value * scalar)));
    }

    static multiply(matrix1, matrix2) {

        if(!(Object.values(arguments).every(matrix => matrix instanceof Matrix4f) && Object.values(arguments).length === 2)) {
            throw new Error('There should be only two matrices in input, both of type Matrix4f!');
        }

        // number of rows in first matrix
        const rows = matrix1.matrix[0].length;

        // number of columns in second matrix
        const columns = matrix2.matrix.length;

        if(rows !== columns) {
            throw new Error('Number of rows in first matrix must match number of columns in second matrix!');
        }

        // multiply values in same indexes and add them together
        const multiplyAndAdd = (a, b) => a && b && a.map((value, i) => value * b[i]).reduce((sum, tmp) => sum + tmp, 0); 

        let newMatrix = [];

        for(let i = 0; i < matrix1.matrix.length; i++) {
            // if array doesn't exist yet
            if(!newMatrix[i]) {
                newMatrix[i] = [];
            }

            for(let j = 0; j < matrix2.matrix[0].length; j++) {
                // multiply row from first matrix with column from second matrix and add it up
                newMatrix[i][j] = multiplyAndAdd(matrix1.matrix[i], this.transpose(matrix2).matrix[j]);
            }
        }

        return new Matrix4f(newMatrix);
    }
}

// test helpers

// const scalar = 2;

// const matrix1 = new Matrix4f([
//     [1, 2],
//     [2, 1]
// ]);

// const matrix2 = new Matrix4f([
//     [1, 2, 3],
//     [3, 2, 1]
// ]);

// const outMatrix = matrix => matrix && Object.values(matrix).forEach(row => console.table(row));

// console.log('Matrix 1:')
// outMatrix(matrix1);

// console.log('Matrix 2:')
// outMatrix(matrix2);

// console.log('Negate Matrix 1: ');
// outMatrix(Matrix4f.negate(matrix1));

// console.log('Add Matrix 1,2: ');
// outMatrix(Matrix4f.add(matrix1, matrix2));

// console.log('Transpose Matrix 1: ');
// outMatrix(Matrix4f.transpose(matrix1));

// console.log('Multiply Matrix 1 with scalar(2): ')
// outMatrix(Matrix4f.multiplyScalar(scalar, matrix1));

// console.log('Multiply Matrix 1 with Matrix 2: ')
// outMatrix(Matrix4f.multiply(matrix1, matrix2));