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

// test helpers

const vector1 = new Vector4f(1, 2, 3);
const vector2 = new Vector4f(3, 2, 1);

console.log('Vektor 1: ', vector1);
console.log('Vektor 2: ', vector2);

console.log('Negate: ', Vector4f.negate(vector1));
console.log('Add: ', Vector4f.add(vector1, vector2));
console.log('Scalar product: ', Vector4f.scalarProduct(5, vector1));
console.log('Dot product: ', Vector4f.dotProduct(vector1, vector2));
console.log('Cross product: ', Vector4f.crossProduct(vector1, vector2));
console.log('Length: ', Vector4f.length(vector1));
console.log('Normalize: ', Vector4f.normalize(vector1));
console.log('Project: ', Vector4f.project(vector1, vector2));
console.log('Cos phi: ', Vector4f.cosPhi(vector1, vector2));