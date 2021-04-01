**STRUCT**

# `CallingNonFunction`

```swift
public struct CallingNonFunction<BaseType>: VMError
```

Throw this when tryng to call an value that is not a function

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
