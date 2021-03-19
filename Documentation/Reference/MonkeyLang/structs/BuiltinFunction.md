**STRUCT**

# `BuiltinFunction`

```swift
public struct BuiltinFunction: Object
```

This is a wrapper for Monkey Language builtin functions
such as `len`

## Properties
### `type`

```swift
public var type: ObjectType
```

### `description`

```swift
public var description: String
```

## Methods
### `init(name:_:)`

```swift
public init(name: String, _ function: @escaping MonkeyFunction)
```

### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

Currently not supported
