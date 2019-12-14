'use strict';

class Vector4f {

    constructor(x, y, z, w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = 1; // homogenous component
    };

    static negate(vector) {
        if(!(vector instanceof Vector4f && Object.keys(vector).length === 4)) {
            throw new Error('Provided vector should be of type Vector4f and should include components x,y,z,w!')
        }

        // multiply components by -1 to negate it
        return new Vector4f(...Object.keys(vector).filter(x => x !== 'w').map(x => vector[x] * -1));
    };

    static add(vector1, vector2) {
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            throw new Error('Provided vectors should be of type Vector4f and should include components x,y,z,w!');
        }

        // sum up all elements at same indexes
        return new Vector4f(...Object.keys(vector1).filter(x => x !== 'w').map((n, i) => vector1[n] + Object.values(vector2)[i]));
    };

    static scalarProduct(scalar, vector) {
        if(typeof(scalar) !== 'number') {
            throw new Error('Provided scalar should be a number!');
        }

        if(!(vector instanceof Vector4f && Object.keys(vector).length === 4)) {
            throw new Error('Provided vector should be of type Vector4f and should include components x,y,z,w!')
        }

        return new Vector4f(...Object.values(vector).map(value => value * scalar));
    };

    static dotProduct(vector1, vector2) {
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            throw new Error('Provided vectors should be of type Vector4f and should include components x,y,z,w!');
        }

        // multiply all elements at same indexes and sum them
        return Object.keys(vector1).filter(x => x !== 'w').map((n, i) => vector1[n] * Object.values(vector2)[i]).reduce((sum, value) => sum + value, 0);
    };

    static crossProduct(vector1, vector2) {
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            throw new Error('Provided vectors should be of type Vector4f and should include components x,y,z,w!');
        }

        const x = vector1.y * vector2.z - vector1.z * vector2.y;
        const y = vector1.z * vector2.x - vector1.x * vector2.z;
        const z = vector1.x * vector2.y - vector1.y * vector2.x;

        return new Vector4f(x, y, z);
    };

    static length(vector) {
        if(!(vector instanceof Vector4f) && Object.keys(vector).length === 4) {
            throw new Error('Provided vector should be of type Vector4f and should include components x,y,z,w!')
        }

        // vector length = second norm = sqrt of sum of all components to the second power
        return Math.sqrt(Object.keys(vector).filter(x => x !== 'w').reduce((length, key) => length + Math.pow(vector[key], 2), 0));
    };

    static normalize(vector) {
        if(!(vector instanceof Vector4f) && Object.keys(vector).length === 4) {
            throw new Error('Provided vector should be of type Vector4f and should include components x,y,z,w!')
        }

        if(this.length(vector) <= 0) {
            throw new Error('Division by zero! Cannot normalize a vector with length of 0!');
        }

        return new Vector4f(...Object.values(vector).map(value => value /= this.length(vector)));
    };

    static project(vector1, vector2) {
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            throw new Error('Provided vectors should be of type Vector4f and should include components x,y,z,w!');
        }

        const dotProduct = this.dotProduct(vector1, vector2);
        const firstLength = this.length(vector1);

        if(firstLength(vector) <= 0) {
            throw new Error('Division by zero! Cannot project a vector with length of 0!');
        }

        // scalar product * (dot product(vector1, vector2) / vector1.length, vector1)
        const scalarProduct = this.scalarProduct(dotProduct / Math.pow(firstLength, 2), vector1);

        return scalarProduct;    
    };

    static cosPhi(vector1, vector2) {
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            throw new Error('Provided vectors should be of type Vector4f and should include components x,y,z,w!');
        }

        const dotProduct = this.dotProduct(vector1, vector2);
        const firstLength = this.length(vector1);
        const secondLength = this.length(vector2);

        // division by zero protection
        if([dotProduct, firstLength, secondLength].includes(0)) {
            return 0;
        }

        // ||vector1|| * ||vector2|| * cos phi = skalarni produkt(vector1, vector2)
        return dotProduct / firstLength / secondLength;
    };
}

// test helpers

// const vector1 = new Vector4f(1, 2, 3);
// const vector2 = new Vector4f(3, 2, 1);

// console.clear();
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