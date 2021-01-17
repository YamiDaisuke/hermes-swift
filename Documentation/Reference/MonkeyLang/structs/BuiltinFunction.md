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
### `init(_:)`

```swift
public init(_ function: @escaping MonkeyFunction)
```
