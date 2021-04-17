**STRUCT**

# `ValueIsNotCompilable`

```swift
public struct ValueIsNotCompilable: CompilerError
```

Throws this if a nested value is not compilable

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
public init(_ value: Any, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
