console.clear();
const elements = [7, 9, 12, 11, 3, 17, 1, 23, 10, 8];

let table1 = [{}, {}, {}, {}, {}];
let table2 = [{}, {}, {}, {}, {}];

const h1 = (k, m) => k % m;
const h2 = (k, m) => Math.floor((k / m)) % m;
const m = 5;

const calculateHashes = (elements, h1, h2) => {
    let result = [];
    elements.forEach(element => {
        result.push({ 
            key: element, 
            hash1: h1(element, m), 
            hash2: h2(element, m) 
        });
    })
    return result
}

const isEmptyObject = (obj) => Object.entries(obj).length === 0 && obj.constructor === Object;
const values = calculateHashes(elements, h1, h2);
const printTables = (table1, table2) => {
    console.log('First table:')
    console.table(table1);
    console.log('Second table:')
    console.table(table2);
};

const insert = k => {
    // indexes for current element being inserted
    const { hash1: position1, hash2: position2 } = values.find(x => x.key === k);

    // if doesn't exist in first table
    if(isEmptyObject(table1[position1])){
        table1[position1] = k;
        console.log(`[${k}] - Inserted element ${k} to position ${position1} in table 1.`)
    }
    else {
        // indexes for previous element (the one we're moving to table 2 now)
        const { hash1: prevPosition1, hash2: prevPosition2 } = values.find(x => x.key === table1[position1]);

        // move previous element to new position 
        table2[prevPosition2] = table1[prevPosition1];
        console.log(`[${k}] - Moved element ${table1[prevPosition1]} to position ${prevPosition2} in table 2.`)

        // insert current element to position
        table1[position1] = k;
        console.log(`[${k}] - Inserted element ${k} to position ${position1} in table 1.`)
    }

    // printTables(table1, table2);
};


insert(7); 
insert(9);
insert(12);
insert(11);
insert(3);
// insert(17)
// insert(1);
// insert(23);
// insert(10);
// insert(8);

printTables(table1, table2);