**STRUCT**

# `ReferenceError`

```swift
public struct ReferenceError: EvaluatorError
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
public init(_ identifier: String, line: Int? = nil, column: Int? = nil)
```
