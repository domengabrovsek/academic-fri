// example 1
const data = {
    suffixes: ["grad", "burg", "ton", "ek"],
    prequalifiers: ["gornji", "doljni", "srednji", "nagy", "kis", "ober", "unter"],
    roots: ["kraven", "boler", "koenig", "pasji", "maczka", "kirchen", "senov", "bistrin", "drenov",
    "raven", "poden", "wegen", "lisen", "kirgen", "krulen", "mulen", "tulen", "bulen", "peter", "pavel", "ekaterin"]
}

let allTowns = [];

for(let suffix of data.suffixes){
    for(let root of data.roots){
        allTowns.push(`${root}${suffix}`);
    }
}

for(let prequalifier of data.prequalifiers){
    for(let suffix of data.suffixes){
        for(let root of data.roots){
            allTowns.push(`${prequalifier} ${root} ${suffix}`);
        }
    }
}

// example 2
function fillGraphMyExample(){
    const nodes = ['S', 'T', 'X', 'Y', 'Z'];

    // add all nodes 
    nodes.forEach(node => addNode(node));

    // add all edges
    addEdge('Z', 'S', 2);
    addEdge('S', 'T', 6);
    addEdge('X', 'T', -2);
    addEdge('T', 'X', 5);
    addEdge('Y', 'X', -3);
    addEdge('Z', 'X', 7);
    addEdge('S', 'Y', 7);
    addEdge('T', 'Y', 8);
    addEdge('Y', 'Z', 9);
    addEdge('T', 'Z', -4);

}

// helpers
const getRandomNumber = (max) => parseInt(Math.random() * (max - 0) + 0);

module.exports = {
    data,
    allTowns,
    getRandomNumber
};