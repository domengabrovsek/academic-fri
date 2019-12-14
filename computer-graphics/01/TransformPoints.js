'use strict';

class TransformPoints {
    
    static Transform(point) {
        const { matrix } = Transformation.transformPoint(point);

        const x = matrix[0][0].toFixed(3);
        const y = matrix[1][0].toFixed(3);
        const z = matrix[2][0].toFixed(3);

        return `v ${x} ${y} ${z}`;
    }
}