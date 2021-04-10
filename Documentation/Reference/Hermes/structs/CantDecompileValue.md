**STRUCT**

# `CantDecompileValue`

```swift
public struct CantDecompileValue: CompilerError
```

Throw this if the bytes fail to be decompiled into the expected type

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
### `init(_:expectedType:line:column:file:)`

```swift
public init(_ bytes: [Byte], expectedType: String, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
