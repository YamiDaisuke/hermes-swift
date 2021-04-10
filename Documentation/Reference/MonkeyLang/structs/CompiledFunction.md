**STRUCT**

# `CompiledFunction`

```swift
public struct CompiledFunction: Object, VMFunctionDefinition
```

Same as `Function` but represented with compiled bytecode instructions

## Properties
### `instructions`

```swift
public var instructions: Instructions
```

### `localsCount`

```swift
public var localsCount: Int
```

### `parameterCount`

```swift
public var parameterCount: Int
```

### `description`

```swift
public var description: String
```

## Methods
### `init(instructions:localsCount:parameterCount:)`

```swift
public init(instructions: Instructions, localsCount: Int = 0, parameterCount: Int = 0)
```

### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | Another Object instance |