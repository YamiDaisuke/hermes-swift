**STRUCT**

# `MonkeyLexer`

```swift
public struct MonkeyLexer: Lexer
```

## Properties
### `readingChars`

```swift
public var readingChars: (current: Character?, next: Character?)?
```

### `filePath`

```swift
public let filePath: URL?
```

### `input`

```swift
public var input: String
```

### `streamReader`

```swift
public var streamReader: StreamReader?
```

### `currentLineNumber`

```swift
public var currentLineNumber = 0
```

### `currentColumn`

```swift
public var currentColumn = 0
```

### `readCharacterCount`

```swift
public var readCharacterCount = 0
```

### `currentLine`

```swift
public var currentLine = ""
```

## Methods
### `init()`

```swift
public init()
```

### `init(withFilePath:)`

```swift
public init(withFilePath filePath: URL)
```

### `init(withString:)`

```swift
public init(withString input: String)
```

### `readLine()`

```swift
public mutating func readLine()
```

### `nextToken()`

```swift
public mutating func nextToken() -> Token
```
