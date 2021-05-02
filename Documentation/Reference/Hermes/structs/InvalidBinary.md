**STRUCT**

# `InvalidBinary`

```swift
public struct InvalidBinary: VMError
```

Throw this error when the VM is trying to execute a binary file
that was not compiled with a Hermes compiler

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
public init(_ filePath: URL, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
