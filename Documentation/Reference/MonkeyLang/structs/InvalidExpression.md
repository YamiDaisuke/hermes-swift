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

## Methods
### `init(_:line:column:)`

```swift
public init(_ token: Token?, line: Int? = nil, column: Int? = nil)
```
