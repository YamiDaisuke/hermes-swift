**STRUCT**

# `Return`

```swift
public struct Return: Object
```

Wrapper tto represent `return`, control transfer statement

## Properties
### `type`

```swift
public var type: ObjectType
```

### `value`

```swift
public var value: Object?
```

The returned value

### `description`

```swift
public var description: String
```

## Methods
### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | Another Object instance |