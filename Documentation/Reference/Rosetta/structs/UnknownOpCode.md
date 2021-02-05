**STRUCT**

# `UnknownOpCode`

```swift
public struct UnknownOpCode: VMError
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

### `file`

```swift
public var file: String?
```

## Methods
### `init(_:)`

```swift
public init(_ code: OpCode)
```
