**EXTENSION**

# `Compiler`
```swift
public extension Compiler
```

## Properties
### `bytecode`

```swift
var bytecode: BytecodeProgram<Self.BaseType>
```

Returns the `BytecodeProgram` with all the compiled instructions

## Methods
### `addConstant(_:)`

```swift
mutating func addConstant(_ value: Self.BaseType) -> Int32
```

Saves a constant value into the constants pool
- Parameter value: The value to store
- Returns: The index corresponding to the stored value

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value to store |

### `addInstruction(_:)`

```swift
mutating func addInstruction(_ instruction: Instructions) -> Int
```

Stores a compiled instruction
- Parameter instruction: The instruction to store
- Returns: The starting index of this instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| instruction | The instruction to store |

### `emit(_:_:)`

```swift
mutating func emit(_ operation: OpCodes, _ operands: Int32...) -> Int
```

Converts an operation and operands into bytecode and store it
- Parameters:
  - operation: The operation code
  - operands: The operands values
- Returns: The starting index of this instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| operation | The operation code |
| operands | The operands values |

### `removeLast(if:)`

```swift
mutating func removeLast(if predicate: ((EmittedInstruction) -> Bool)? = nil)
```

Removes the las instruction from the emmited instruction with an optional predicate
- Parameter predicate: An optional predicate to choose whether or not to remove the last instruction
                       if no predicate is supplied the instruction is removed

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | An optional predicate to choose whether or not to remove the last instruction if no predicate is supplied the instruction is removed |

### `replaceInstructionAt(_:with:)`

```swift
mutating func replaceInstructionAt(_ position: Int, with newInstruction: Instructions)
```

Replace instruction bytes starting at `position` with `newInstruction`
- Parameters:
  - position: The starting position to replace
  - newInstruction: The new instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| position | The starting position to replace |
| newInstruction | The new instruction bytes |

### `replaceOperands(operands:at:)`

```swift
mutating func replaceOperands(operands: [Int32], at position: Int)
```
