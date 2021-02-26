**STRUCT**

# `IndexNotSupported`

```swift
public struct IndexNotSupported<BaseType>: VMError
```

Throw this when tryng to apply an index expression to a non-indexable value

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
public init(_ value: BaseType)
```
