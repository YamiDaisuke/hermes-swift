# Rosetta Swift

[![YourActionName Actions Status](https://github.com/YamiDaisuke/rosetta-swift/workflows/BuildAndTest/badge.svg)](https://github.com/YamiDaisuke/rosetta-swift/actions)
[![codecov](https://codecov.io/gh/YamiDaisuke/rosetta-swift/branch/main/graph/badge.svg?token=14CTPDWLQW)](https://codecov.io/gh/YamiDaisuke/rosetta-swift)
## Introduction

With this project I want to get a better understanding on how compilers and interpreters works, while
also have fun in the process 😎🤓. For that purpose  I'll be following this book series:

- [Writing An Interpreter In Go](https://interpreterbook.com)
- [Writing A Compiler In Go](https://compilerbook.com)

What I like about this two books is that requires no third party or existing libraries it takes you through
the entire process of making the interpreter and the compiler. The result might not be a production
ready software but will accomplish what I'm looking for which is to learn how they work internally without any
black box magic.

The book uses a language called Monkey designed for the book. From the book page the language is described as follows:

> Monkey has a C-like syntax, supports variable bindings, prefix and infix operators, has first-class and
> higher-order functions, can handle closures with ease and has integers, booleans, arrays and hashes
> built-in.

The book uses Go Lang for the implementation but I want to do it in swift just because I like swift ❤️. For
starters I will be using an XCode to compile and test my implementation, later on I'll try to implement a
standalone compilation and maybe include support for linux. As in the book this implementation will not
use third party libs only standard swift libraries. Maybe I'll include a lib to simplify the CLI
implementation but nothing else.

## Before you begin

After cloning this repo run `./scripts/install-hooks.sh` to configure git hooks. This will ensure documentation
is update on each commit and will prevent broken tests and lint errors to be pushed in the repo.

## TODO

Outside the scope of the book my current stretch goals (so far) and aditional taks are:

- [X] Create each component as a swift package not tied to the Monkey language, the idea is that you can
implement a series of `protocols` and `classes` and provide your very own language that should work
with this library
- [X] Modify Lexer to include line and column information for each token
- [ ] Modify Lexer to read from files and parse tokens line by line
- [X] Implement CI steps
- [X] Create an standalone build and test script to work without XCode
- [ ] CI steps to build release artifacts
- [ ] Support Linux

## Language Extra Features

Besides the language features include in the books, I have added the following by my own:

### String scape sequences

Support of scape characters inside string literals, currently supported values are:
```
\n = line break
\t = tabulation
\" = Double quote character inside a string
\\ = Back slash character
```
Any other value will produce an error

### String compare

Comparison of String values with any other value.

- Two strings will be compared based on their characters
- A string will be equal to boolean `true` if it is not empty
- A string will be equal to boolean `false` if it is empty
- A string will never be equal to any other value

## Documentation

Documentation can be found [here](Documentation/Reference/README.md)
