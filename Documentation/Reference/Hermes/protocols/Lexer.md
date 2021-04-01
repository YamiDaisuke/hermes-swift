**PROTOCOL**

# `Lexer`

```swift
public protocol Lexer
```

This protocol describes the interface for any language
lexer

## Properties
### `currentLineNumber`

```swift
var currentLineNumber: Int
```

### `currentColumn`

```swift
var currentColumn: Int
```

The position of the current `Character` in the current line

### `currentLine`

```swift
var currentLine: String
```

The line we are currently tokenizing

### `readingChars`

```swift
var readingChars: (current: Character?, next: Character?)?
```

The `Character` we are currently tokenizing and a peek of
the next one

### `readCharacterCount`

```swift
var readCharacterCount: Int
```

How many `Characters` we have actually read

## Methods
### `nextToken()`

```swift
mutating func nextToken() -> Token
```

Should read this `Lexer` input source and return the next parsed
`Token` instance
- Returns: A valid `Token` instance for the current language

### `readLine()`

```swift
mutating func readLine()
```

Reads the next line and moves the
`currentLineNumber` and `currentColumn`
pointers of the `Lexer` to the right value
