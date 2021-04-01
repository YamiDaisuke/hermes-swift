**PROTOCOL**

# `StringLexer`

```swift
public protocol StringLexer: Lexer
```

A Lexer that uses a `String` as input for processing

## Properties
### `input`

```swift
var input: String
```

## Methods
### `readStringLine()`

```swift
mutating func readStringLine()
```

Reads the next line in the input `String` and moves the
`currentLineNumber` and `currentColumn`
pointers of the `Lexer` to the right value
