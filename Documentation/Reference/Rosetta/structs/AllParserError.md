**STRUCT**

# `AllParserError`

```swift
public struct AllParserError: ParseError
```

Helper error struct, so we can accumulate all errors
found while parsing the program instead of just stoping
the loop at first error

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

### `description`

```swift
public var description: String
```

Returns the description of all accumulated errors

## Methods
### `init(withErrors:)`

```swift
public init(withErrors errors: [ParseError])
```
