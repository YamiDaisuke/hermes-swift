**PROTOCOL**

# `Compiler`

```swift
public protocol Compiler
```

Base Compiler structure for Rosetta VM

## Properties
### `instructions`

```swift
var instructions: Instructions
```

Holds all the compiled instructions bytes

### `lastInstruction`

```swift
var lastInstruction: EmittedInstruction?
```

Holds the last emitted instruction

### `prevInstruction`

```swift
var prevInstruction: EmittedInstruction?
```

Holds the previous emitted instruction

### `constants`

```swift
var constants: [BaseType]
```

A pool of the compiled constant values

### `bytecode`

```swift
var bytecode: BytecodeProgram<BaseType>
```

Puts all the compiled values into a single `BytecodeProgram`

## Methods
### `compile(_:)`

```swift
mutating func compile(_ program: Program) throws
```

Traverse a parsed `Program` an creates the corresponding Bytecode
- Parameter program: The program

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |

### `compile(_:)`

```swift
mutating func compile(_ node: Node) throws
```

Traverse a parsed AST an creates the corresponding Bytecode
- Parameter program: The program

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |