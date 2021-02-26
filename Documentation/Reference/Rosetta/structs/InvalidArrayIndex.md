**STRUCT**

# `InvalidArrayIndex`

```swift
public struct InvalidArrayIndex<BaseType>: VMError
```

Throw this when a value from the base lang is not usable as index for arrays

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
public init(_ index: BaseType)
```
