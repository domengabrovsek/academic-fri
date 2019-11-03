// cutting rods
// calculate whether to sell the rods of the original length or 
// to cut them into smaller segments and sell those separately in order to maximize profit. 
// compute the optimal segment lengths and the highest possible income.

const data = [
    {
        length: 1,
        price: 2
    },
    {
        length: 2,
        price: 4
    },
    {
        length: 3,
        price: 7
    },
    {
        length: 4,
        price: 9
    },
    {
        length: 5,
        price: 10
    },
    {
        length: 6,
        price: 11
    },
    {
        length: 7,
        price: 12
    },
    {
        length: 8,
        price: 19
    },
    {
        length: 9,
        price: 22
    }
];

const outputResults = (data, func) => {
    console.log(`\n${func.name}: \n`);
    data.forEach(x => console.log(`l: ${x.length}, p: ${x.price}, r: ${func(data.map(x => x.price), x)}`));
}

// naive solution
function getRevenueNaive(prices, element){
    if(element.length <= 0) return 0;
    let max = 0;
    for(let i = 0; i < element.length; i++){
        max = Math.max(max, prices[i] + getRevenueNaive(prices, element.length - i - 1));
    }

    return max;
}

// solution using dynamic programming
function getRevenue(prices, element){
    let values = [0];

    for(let i = 0; i <= element.length; i++){
        let max = 0;
        for(let j = 0; j < i; j++){
            max = Math.max(max, prices[j] + values[i - j - 1]);
        }
        
        values[i] = max;
    }
    return values[element.length];
}

// solution using dynamic programming when for each cut we have to pay 2 units
function getRevenueWithCuts(prices, element){
    let values = [0];

    for(let i = 0; i <= element.length; i++){
        let max = 0;
        for(let j = 0; j < i; j++){
            // console.log(`i:${i}, j:${j}, (${prices[j]}) + (${values[i - j -1]})`);
            max = Math.max(max, prices[j] + values[i - j - 1]);
        }
        values[i] = max;
    }

    // if p and r are different this means we made a cut so we subtract 2 units from price (cost is 2 units per cut)
    if(values[element.length] !== element.price){
        values[element.length] = Math.max(values[element.length] - 2, element.price);
    }

    return values[element.length];
}

// TODO
// solution using dynamic programming when for each cut we have to pay b/a units where a is the shorter rod and
// where b/a is the ratio between the newly obtained rod lengths, and a <= b ).
function getRevenueWithCutsTwo(prices, element){
    let values = [0];

    for(let i = 0; i <= element.length; i++){
        let max = 0;
        for(let j = 0; j < i; j++){
            console.log(`i:${i}, j:${j}, (${prices[j]}) + (${values[i - j -1]})`);
            max = Math.max(max, prices[j] + values[i - j - 1]);
        }
        values[i] = max;
    }

    // if p and r are different this means we made a cut so we subtract 2 units from price (cost is 2 units per cut)
    if(values[element.length] !== element.price){
        values[element.length] = Math.max(values[element.length], element.price);
    }

    return values[element.length];
}

outputResults(data, getRevenueNaive);
outputResults(data, getRevenue);
outputResults(data, getRevenueWithCuts);
//outputResults(data, getRevenueWithCutsTwo);