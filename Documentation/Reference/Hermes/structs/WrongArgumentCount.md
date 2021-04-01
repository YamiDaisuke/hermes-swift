**STRUCT**

# `WrongArgumentCount`

```swift
public struct WrongArgumentCount: VMError
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
### `init(_:got:line:column:file:)`

```swift
public init(_ expected: Int, got: Int, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
