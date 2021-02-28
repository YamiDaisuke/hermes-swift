**EXTENSION**

# `Compiler`
```swift
public extension Compiler
```

## Properties
### `currentScope`

```swift
var currentScope: CompilationScope
```

Gets the current `CompilationScope`

### `currentInstructions`

```swift
var currentInstructions: Instructions
```

Returns the instructions from the current compilation scope

### `bytecode`

```swift
var bytecode: BytecodeProgram<Self.BaseType>
```

Returns the `BytecodeProgram` with all the compiled instructions

## Methods
### `enterScope()`

```swift
mutating func enterScope()
```

Activates a new compilation scopes

### `leaveScope()`

```swift
mutating func leaveScope() -> Instructions
```

Closes the current compilation scope and returns the compiled instructions

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

### `replaceOperands(operands:at:)`

```swift
mutating func replaceOperands(operands: [Int32], at position: Int)
```

Replace a list operands starting a given position
- Parameters:
  - operands: The operands to replace
  - position: The position where to insert

#### Parameters

| Name | Description |
| ---- | ----------- |
| operands | The operands to replace |
| position | The position where to insert |

### `lastInstructionIs(_:)`

```swift
func lastInstructionIs(_ code: OpCodes) -> Bool
```

Checks if the last emited instructions matches a given code
- Parameter code: The code to look for
- Returns: `true` if the last emitted code is equals to `code`

#### Parameters

| Name | Description |
| ---- | ----------- |
| code | The code to look for |