
Hoisting in JavaScript: A Practical Guide

## Introduction

Hoisting is an important concept in JavaScript that can often lead to confusion for developers, especially those new to the language. In this article, we'll break down hoisting in detail using practical code examples, focusing on variable and function declarations.

## Variable Declaration Hoisting

```js
var x;

console.log(
        `x will not throw a ReferenceError, but its value will be undefined --> x:${x} because it uses "declaration hoisting"`
        );
```

Here, we declare a variable `x` using the `var` keyword. When the JavaScript engine runs the code, it hoists the declaration to the top of the current scope. As a result, we can access `x` without encountering a ReferenceError, although its value is initially `undefined`.

## Block Scope and `var`

```js
{
    {
        {
            var x = 1;
        }
    }
    console.log(`${x} can be accessed outside the block scope`);
}
```

Using the `var` keyword, we declare and assign the variable `x` a value of `1` inside a nested block scope. However, due to the nature of `var`, the variable can still be accessed outside the block scope, as shown in the console log statement.

## Block Scope and `const`

```js
{
    {
        const y = 2;

        console.log(`${y} can only be accessed in this block and child blocks`);
        {
            console.log(`${y} can only be accessed in this block and child blocks`);
        }
    }

    console.log("y can't be accessed here");
}
```

Here, we declare a constant variable `y` inside a block scope using the `const` keyword. Unlike `var`, `const` (and `let`) follow block scoping rules, meaning `y` can only be accessed within the block it was declared in and its child blocks.

## Declaration Hoisting with `let`

```js
{
    let z;
    console.log(
            `z will not throw a ReferenceError, but its value will be undefined --> z:${z} because it uses "declaration hoisting"`
            );
}
```

Similar to `var`, the `let` keyword allows for declaration hoisting. However, `let` adheres to block scoping rules, so its value can only be accessed within the block it was declared in.

## Function Hoisting

```js
myFavoriteFunction();

function myFavoriteFunction() {
    console.log(
            'This function can be called anywhere in the file because it uses `value hoisting`!'
            );
}
```

In this example, we define a function using a function declaration. Functions declared this way are hoisted to the top of their scope, allowing them to be called before their declaration in the code.

## No Value Hoisting with Function Expressions

```js
const mySecondFavoriteFunction = function () {
    console.log('This function can only be called after it is defined');
};

mySecondFavoriteFunction();
```

Here, we define a function using a function expression and assign it to a constant variable `mySecondFavoriteFunction`. Unlike function declarations, function expressions are not hoisted to the top of their scope. This means that the function can only be called after the point in the code where it is defined. Attempting to call the function before its definition will result in a ReferenceError.

## Assigning a New Value to a Hoisted Variable

```js
var x = 1;

{
    {
        x = 2;
    }
}

console.log(`${x} is always hoisted to the top of the scope it is declared in so it will always be 2 here`);
```

In this example, we declare a variable `x` using the `var` keyword and assign it a value of `1`. Inside a nested block scope, we then reassign the value of `x` to `2`. As `var` variables are hoisted to the top of the scope they are declared in, the value of `x` will always be `2` at the point of the console log statement.

## Redeclaring a Hoisted Variable within a Child Scope

```js
var x = 1;

{
    {
        var x = 2;
    }
}

console.log(
        `${x} is always hoisted to the top of the scope it is declared in so it will always be 2 here, even when it is redeclared in a child scope`
        );
```

In this example, we again declare a variable `x` using the `var` keyword and assign it a value of `1`. However, this time we redeclare the variable `x` inside a nested block scope, assigning it a new value of `2`. Since `var` variables are hoisted to the top of the scope they are declared in and do not follow block scoping rules, the value of `x` will always be `2` at the point of the console log statement, even when it is redeclared in a child scope.

## Conclusion

Understanding hoisting in JavaScript is crucial for writing clean, bug-free code. By familiarizing yourself with how variable and function declarations are hoisted, as well as the differences between function declarations and function expressions, and how reassigning and redeclaring variables within different scopes impact hoisting behavior, you can better predict the behavior of your code and avoid potential issues.


