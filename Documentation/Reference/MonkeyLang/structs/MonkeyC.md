**STRUCT**

# `MonkeyC`

```swift
public struct MonkeyC: Compiler
```

Monkey Lang compiler for the Rosetta VM

## Properties
### `instructions`

```swift
public var instructions: Instructions = []
```

### `lastInstruction`

```swift
public var lastInstruction: EmittedInstruction?
```

### `prevInstruction`

```swift
public var prevInstruction: EmittedInstruction?
```

### `constants`

```swift
public var constants: [Object] = []
```

## Methods
### `init()`

```swift
public init()
```

### `compile(_:)`

```swift
public mutating func compile(_ program: Program) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |

### `compile(_:)`

```swift
public mutating func compile(_ node: Node) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |