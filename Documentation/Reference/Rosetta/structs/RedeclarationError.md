**STRUCT**

# `RedeclarationError`

```swift
public struct RedeclarationError: EvaluatorError
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
public init(_ name: String, line: Int? = nil, column: Int? = nil)
```
