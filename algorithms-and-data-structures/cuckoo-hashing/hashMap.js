const universalSet = {
    0: 'A',
    1: 'B',
    2: 'C',
    3: 'Č',
    4: 'D',
    5: 'E',
    6: 'F',
    7: 'G',
    8: 'H',
    9: 'I',
    10: 'J',
    11: 'K',
    12: 'L',
    13: 'M',
    14: 'N',
    15: 'O',
    16: 'P',
    17: 'R',
    18: 'S',
    19: 'Š',
    20: 'T',
    21: 'U',
    22: 'V',
    23: 'Z',
    24: 'Ž'
};

const p = 11;
const m = 7;
const toInsert = ['P', 'O', 'D', 'A', 'T', 'E', 'K'];

const hashFunction = (k, p, m) => ({ key: k, value: (p * k) % m });

const getData = (universalSet) => {
    let indexes = []
    toInsert.forEach(letter => {
        for(let index in universalSet){
            if(universalSet[index] === letter){
                indexes.push({ key: index, value: letter });
            }
        }
    });
    return indexes;
};

const getHashValues = (indexes, p, m) => {
    let result = [];
    indexes.forEach(index => {
        let { value: hashValue, key: hashKey } = hashFunction(index.key, p, m);
        result.push({ value: index.value, key: hashKey, hashValue: hashValue });
    })

    return result;
};

const bruteForce = (indexes, p) => {
    for(let m = 1; m < 10000; m++){
        let result = getHashValues(indexes, p, m).map(x => x.hashValue);
        let resultSet = new Set(result);
    
        if(resultSet.size === result.length){
            return { p, m, result };
        }
    }
};

let indexes = getData(universalSet);
let hashValues = getHashValues(indexes, p, 7);

for(let p = 0; p < 15; p++) {
    console.log(bruteForce(indexes, p));
}
