**STRUCT**

# `ReferenceError`

```swift
public struct ReferenceError: EvaluatorError
```

Thrown by default `Environment` implementation contained by this package
when trying to read a value not saved

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
public init(_ identifier: String, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
