**STRUCT**

# `UnknowValueType`

```swift
public struct UnknowValueType: CompilerError
```

Throw this if the first bytes of a compiled value does not match
a type supported by the language

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
public init(_ type: String, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
