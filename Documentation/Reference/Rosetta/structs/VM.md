**STRUCT**

# `VM`

```swift
public struct VM<BaseType, Operations: VMOperations> where Operations.BaseType == BaseType
```

Rosetta VM implementation

## Properties
### `stackTop`

```swift
public var stackTop: BaseType?
```

Returns the current value sitting a top of the stack if the stack is empty returns `nil`

## Methods
### `init(_:operations:)`

```swift
public init(_ bytcode: BytecodeProgram<BaseType>, operations: Operations)
```

Init a new VM with a set of bytecode to run
- Parameters:
  - bytcode: The compiled bytecode
  - operations: An implementation of `VMOperations` in charge of applying the language
                specific operations for this VM

#### Parameters

| Name | Description |
| ---- | ----------- |
| bytcode | The compiled bytecode |
| operations | An implementation of `VMOperations` in charge of applying the language specific operations for this VM |

### `run()`

```swift
public mutating func run() throws
```

Runs the VM against the assigned bytecode
- Throws: `VMError` if anything fails while interpreting the bytecode
