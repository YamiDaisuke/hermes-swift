**STRUCT**

# `MissingExpected`

```swift
public struct MissingExpected: ParseError
```

Throw this error when the next token is not what the
parser expects. E.G.: `let a 5;` should throw this
error because it misses an equals sign between `a` and `5`

## Properties
### `message`

```swift
public var message: String
```

### `line`

```swift
public var line: Int?
```

### `column`

```swift
public var column: Int?
```

### `file`

```swift
public var file: String?
```

## Methods
### `init(type:line:column:file:)`

```swift
public init(type: Token.Kind, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
