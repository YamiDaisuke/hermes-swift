**STRUCT**

# `InvalidHashKey`

```swift
public struct InvalidHashKey<BaseType>: VMError
```

Throw this when a value from the base lang is not usable as Hash key

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
public init(_ key: BaseType)
```
