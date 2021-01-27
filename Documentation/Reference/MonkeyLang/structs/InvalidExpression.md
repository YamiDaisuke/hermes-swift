**STRUCT**

# `InvalidExpression`

```swift
public struct InvalidExpression: ParseError
```

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
### `init(_:line:column:file:)`

```swift
public init(_ token: Token?, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
