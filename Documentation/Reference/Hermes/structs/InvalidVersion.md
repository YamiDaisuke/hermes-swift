**STRUCT**

# `InvalidVersion`

```swift
public struct InvalidVersion: VMError
```

Throw this error when the VM is trying to execute a binary file
that it is targeting an incompatible Hermes version

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
### `init(_:expected:line:column:file:)`

```swift
public init(_ current: SemVersion, expected: SemVersion, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
