**PROTOCOL**

# `FileLexer`

```swift
public protocol FileLexer: Lexer
```

A Lexer that uses a file as the input for processing

## Properties
### `filePath`

```swift
var filePath: URL?
```

### `streamReader`

```swift
var streamReader: StreamReader?
```

## Methods
### `readFileLine()`

```swift
mutating func readFileLine()
```

Reads the next line in the file and moves the
`currentLineNumber` and `currentColumn`
pointers of the `Lexer` to the right value
