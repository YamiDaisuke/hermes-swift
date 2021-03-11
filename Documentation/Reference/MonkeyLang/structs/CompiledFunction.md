**STRUCT**

# `CompiledFunction`

```swift
public struct CompiledFunction: Object
```

Same as `Function` but represented with compiled bytecode instructions

## Properties
### `type`

```swift
public var type: ObjectType
```

### `instructions`

```swift
public var instructions: Instructions
```

### `localsCount`

```swift
public var localsCount: Int
```

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