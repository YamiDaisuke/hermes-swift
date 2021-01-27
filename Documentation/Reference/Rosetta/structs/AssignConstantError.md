**STRUCT**

# `AssignConstantError`

```swift
public struct AssignConstantError: EvaluatorError
```

Thrown by default `Environment` implementation contained by this package
when trying to change the value of a constant

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
public init(_ name: String, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
