'use strict';

class PointManager {

    static ReadPoints(input) {
        const points = input.split('v').filter(x => x.split(' ').length === 4);

        const pointsString = Object.values(points).length > 0 && Object.values(points)[0].split(' ').filter(x => x);
        const pointsFloat = pointsString && pointsString.map(x => parseFloat(x)).filter(x => x);

        if(pointsString.length !== pointsFloat.length) {
            throw new Error('Provided input is not a number. Please provide valid numbers!');
        }

        return points.map(x => {
            x = x.replace('\n', '');
            const values = x.split(' ').filter(x => x !== '').map(x => parseFloat(x));
            return new Vector4f(...values, 1);
        });
    }
}