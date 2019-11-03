const t = 'CGTCAGCTCGCCTCCTCGCTCCTCGA'; // text where we search in
const p = 'CCTCG'; // pattern we're searching for
const n = t.length; // length of t
const m = p.length; // length of p
const alphabet = Array.from(new Set(t.split(''))); // remove duplicates hack

const createDFA = (alphabet, m) => {    
    let table = [];
    alphabet.forEach(letter => {
        table[letter] = [];
        for(let i = 0; i <= m; i++){
            table[letter][i] = 0;
        }
    });

    return table;
};

// create initial DFA table 
let DFA = createDFA(alphabet, m);

console.log(`Text: ${t} (${t.length})`);
console.log(`Pattern: ${p} (${p.length})`);
console.log(`Alphabet: ${alphabet}`);
console.log('Starting DFA: ');
console.table(DFA);

// start of algorithm
DFA[p[0]][0] = 1;

// for each element in p (m = length)
for(let i = 1, x = 0; i < m; i++){
    const before = { x, i };

    // for each letter in defined alphabet
    for(let c = 0; c < alphabet.length; c++){
        let letter = alphabet[c];
        // console.log(`c: ${letter}, i: ${i}, x: ${x}`);
        DFA[letter][i] = DFA[letter][x];
    }

    DFA[p[i]][i] = i + 1;
    x = DFA[p[i]][x];

    const after = { x, i};

    console.log(`Before: x = ${before.x}, i = ${before.i}`);
    console.log(`After: x = ${after.x}, i = ${after.i}`);

    // output after each step
    console.log(`DFA after step ${i}`);
    console.table(DFA)
}

console.log('Final DFA:');
console.table(DFA);