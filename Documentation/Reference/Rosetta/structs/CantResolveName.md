**STRUCT**

# `CantResolveName`

```swift
public struct CantResolveName: CompilerError
```

Throw this if a name does not exists in the symbol table

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
