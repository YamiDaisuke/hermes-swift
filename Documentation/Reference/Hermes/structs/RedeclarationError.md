**STRUCT**

# `RedeclarationError`

```swift
public struct RedeclarationError: EvaluatorError, CompilerError
```

Thrown by default `Environment` implementation contained by this package
when trying to create a new variable o constant with an already used name

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
