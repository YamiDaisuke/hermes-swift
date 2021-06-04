# Hermes Swift

[![macOS Test](https://github.com/YamiDaisuke/hermes-swift/workflows/macOS%20Test/badge.svg)](https://github.com/YamiDaisuke/hermes-swift/actions)
[![Linux Test](https://github.com/YamiDaisuke/hermes-swift/workflows/Linux%20Test/badge.svg)](https://github.com/YamiDaisuke/hermes-swift/actions)
[![codecov](https://codecov.io/gh/YamiDaisuke/hermes-swift/branch/main/graph/badge.svg?token=14CTPDWLQW)](https://codecov.io/gh/YamiDaisuke/hermes-swift)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

A Lexer, Parser, Interpreter, VM and compiler library built with swift, supporting the addition of new languages
and currently implemented for the [Monkey Language](https://monkeylang.org).

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
standalone compilation. As in the book this implementation will not use third party libs only standard
swift libraries. Maybe I'll include a lib to simplify the CLI implementation but nothing else.

## Before you begin

After cloning this repo run `./scripts/install-hooks.sh` to configure git hooks. This will ensure documentation
is update on each commit and will prevent broken tests and lint errors to be pushed in the repo.

## Documentation

Documentation can be found [here](Documentation/Reference/README.md)

## Install Monkey CLI

Download the latest release binaries or compile using `swift build -c release` and include the `monkey` binary in your path. Then execute:

```bash
## To start the interactive REPL console. By default will use
## interpreter mode
$ monkey

## To start the interactive REPL console using compiled
## mode
$ monkey -m compiler

### To evaluate a file containing Monkey code
$ monkey filename.mk -m interpreter

### To compile a file containing Monkey code
$ monkey filename.mk -m compiler

### This option will also compile a file by default
$ monkey filename.mk

### To run a Monkey binary file containing
$ monkey filename.mkc

### To dump a Monkey binary file bytecode
$ monkey filename.mkc -d
```

## Using the REPL

![](./images/repl.gif)

While using the REPL:

- Type `.exit` or `ctrl+c` to close the session
- Type `ctrl+c` to clean the screen

## Language Extra Features

Besides the language features include in the books, I have added the following by my own:

### Support for floating point values

Floats are now supported with the same operation as integers.
When an expression uses both float and integer value the resulting
value will be a float.

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

### Constants and variables

Support of declaration constants using `let <identifier> = <expression>;`
and variables using `var <identifier> = <expression>;`.

Variables can later be assigned to new values but the value must be
the same type for example the following lines will produce an error:

```
var a = 10;
a = true;
```

### Comments

Support for single line and multiline comments using `//` and `/**/` respectively

```
let a = 42; // Meaning of life
/*
Well it actually is:
"""
Answer to the Ultimate Question of Life, the Universe, and Everything
"""
*/
puts(a);
```
---
## Disclaimer

Initially, I named the project "Rosetta" thinking about the archeological artifact associated
with language translation and interpretation, the name made sense however I completely
forgot about Apple's Rosetta, only after a couple of days working on the repo the name clicked
in my mind. To avoid the confusion the name can generate I have switched to the name "Hermes" after
the greek god associated with language.

I'll remove all references to previous name, but I might miss a couple, please forgive me.
