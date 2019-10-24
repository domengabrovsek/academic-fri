'use strict';

class Vector4f {

    constructor(x, y, z, w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = 1; // homogena komponenta
    };

    // negacija vektorja
    static negate(vector) {
        // check za pravi tip in dolžino inputa
        if(!(vector instanceof Vector4f && Object.keys(vector).length === 4)) {
            return new Error('Vhod mora biti tipa Vector4f in more vsebovati koordinate x,y,z,w!')
        }

        // pomnoži vse komponente z -1
        return new Vector4f(...Object.keys(vector).filter(x => x !== 'w').map(x => vector[x] * -1));
    };

    // seštevek dveh vektorjev
    static add(vector1, vector2) {
        // check za pravi tip in dolžino inputa
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            return new Error('Vhod morata biti dva vektorja tipa Vector4f in morata vsebovati koordinate x,y,z!');
        }

        // seštej vse istoležne elemente
        return new Vector4f(...Object.keys(vector1).filter(x => x !== 'w').map((n, i) => vector1[n] + Object.values(vector2)[i]));
    };

    // produkt s skalarjem
    static scalarProduct(scalar, vector) {
        // skalar mora biti številka
        if(typeof(scalar) !== 'number') {
            return new Error('Skalar mora biti številka!')
        }
        // check za pravi tip in dolžino inputa
        if(!(vector instanceof Vector4f && Object.keys(vector).length === 4)) {
            return new Error('Podan vektor mora biti tipa Vector4f in mora vsebovati koordinate x,y,z,w');
        }

        return new Vector4f(...Object.values(vector).map(value => value * scalar));
    };

    // skalarni produkt
    static dotProduct(vector1, vector2) {
        // check za pravi tip in dolžino inputa
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            return new Error('Vhod morata biti dva vektorja tipa Vector4f in morata vsebovati koordinate x,y,z,w!');
        }

        // zmnoži istoležne elemente in jih seštej
        return Object.keys(vector1).filter(x => x !== 'w').map((n, i) => vector1[n] * Object.values(vector2)[i]).reduce((sum, value) => sum + value, 0);

    };

    // vektorski produkt
    static crossProduct(vector1, vector2) {
        // check za pravi tip in dolžino inputa
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            return new Error('Vhod morata biti dva vektorja tipa Vector4f in morata vsebovati koordinate x,y,z,w!');
        }

        const x = vector1.y * vector2.z - vector1.z * vector2.y;
        const y = vector1.z * vector2.x - vector1.x * vector2.z;
        const z = vector1.x * vector2.y - vector1.y * vector2.x;

        return new Vector4f(x, y, z);
    };

    // dolžina vektorja = druga norma = kvadratni koren vsote vseh komponent na drugo potenco
    static length(vector) {
        if(!(vector instanceof Vector4f) && Object.keys(vector).length === 4) {
            return new Error('Vhod mora biti tipa Vector4f in more vsebovati koordinate x,y,z,w.')
        }

        return Math.sqrt(Object.keys(vector).filter(x => x !== 'w').reduce((length, key) => length + Math.pow(vector[key], 2), 0));
    };

    // normalizacija vektorja
    static normalize(vector) {
        if(!(vector instanceof Vector4f) && Object.keys(vector).length === 4) {
            return new Error('Vhod mora biti tipa Vector4f in more vsebovati koordinate x,y,z,w.')
        }

        // vektorja z dolžino 0 ne moremo normalizirati
        if(this.length(vector) <= 0) {
            return new Error('vektorja z dolžino 0 ne moremo normalizirati!');
        }

        return new Vector4f(...Object.values(vector).map(value => value /= this.length(vector)));
    };

    // produkt s skalarjem * (skalarni produkt(vektor, vektor2) / dolžina prvega vektorja, vektor1)
    static project(vector1, vector2) {
        // check za pravi tip in dolžino inputa
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            return new Error('Vhod morata biti dva vektorja tipa Vector4f in morata vsebovati koordinate x,y,z,w!');
        }

        const dotProduct = this.dotProduct(vector1, vector2);
        const firstLength = this.length(vector1);

        if(firstLength <= 0) {
            return new Error('Vektorja z dolžino 0 ne moremo projecirati!');
        }

        const scalarProduct = this.scalarProduct(dotProduct / Math.pow(firstLength, 2), vector1);

        return scalarProduct;    
    };

    // ||vector1|| * ||vector2|| * cos phi = skalarni produkt(vector1, vector2)
    static cosPhi(vector1, vector2) {
        // check za pravi tip in dolžino inputa
        if(!(Object.values(arguments).every(vector => vector instanceof Vector4f && Object.keys(vector).length === 4) && Object.values(arguments).length === 2)) {
            return new Error('Vhod morata biti dva vektorja tipa Vector4f in morata vsebovati koordinate x,y,z,w!');
        }

        const dotProduct = this.dotProduct(vector1, vector2);
        const firstLength = this.length(vector1);
        const secondLength = this.length(vector2);

        // preprečimo deljenje z 0
        if([dotProduct, firstLength, secondLength].includes(0)) {
            return 0;
        }

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