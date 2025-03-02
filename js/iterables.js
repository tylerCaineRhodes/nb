t myObject = {
    a: 'a',
    b: 'b',
    c: 'c',
};
const myArray = ['a', 'b', 'c'];
const myMap = new Map();
myMap.set('a-key', 'a');
myMap.set('b-key', 'b');
myMap.set('c-key', 'c');
const mySet = new Set(['a', 'b', 'c']);

console.log(myObject);
console.log(myArray);
console.log(myMap);
console.log(mySet);

// accessing keys
for (const key in myObject) console.log(key);
for (const key in myArray) console.log(key);

//note: iterable objects must use the "of" keyword.
for (const key of myMap.keys()) console.log(key);
for (const key of mySet.keys()) console.log(key);

// accessing values
for (const value of Object.values(myObject)) console.log(value);
for (const value of myArray) console.log(value);
for (const value of myMap.values()) console.log(value);
for (const value of mySet) console.log(value);
for (const value of mySet.values()) console.log(value);

// accessing key-value pairs
for (const keyval of myMap) console.log(keyval);
for (const keyval of mySet.entries()) console.log(keyval);
for (const keyval of Object.entries(myObject)) console.log(keyval);
for (const keyval of Object.entries(myArray)) console.log(keyval);

