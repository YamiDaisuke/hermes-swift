**STRUCT**

# `MFloat`

```swift
public struct MFloat: Object, Hashable
```

An Float value in Monkey

## Properties
### `type`

```swift
public var type: ObjectType
```

### `value`

```swift
public var value: Float64
```

### `description`

```swift
public var description: String
```

## Methods
### `init(_:)`

```swift
public init(_ value: Float64)
```

### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | Another Object instance |

### `-(_:)`

```swift
public static prefix func - (rhs: MFloat) -> MFloat
```

Returns the result of multiply the value of this `MFloat` by -1
- Parameter rhs: The `MFloat`value
- Returns: Negative `rhs` if it is Positive and Positve `rhs` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| rhs | The `MFloat`value |