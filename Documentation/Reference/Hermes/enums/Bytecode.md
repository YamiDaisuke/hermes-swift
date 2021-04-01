**ENUM**

# `Bytecode`

```swift
public enum Bytecode
```

## Methods
### `make(_:_:)`

```swift
public static func make(_ op: OpCodes, _ operands: Int32...) -> Instructions
```

Converts abstract representation into Hermes VM bytecode instructions
- Parameters:
  - op: The instruction `OpCode`
  - operands: The operands values
- Returns: The instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| op | The instruction `OpCode` |
| operands | The operands values |

### `make(_:operands:)`

```swift
public static func make(_ op: OpCodes, operands: [Int32] = []) -> Instructions
```

Converts abstract representation into Hermes VM bytecode instructions
- Parameters:
  - op: The instruction `OpCode`
  - operands: The operands values
- Returns: The instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| op | The instruction `OpCode` |
| operands | The operands values |

### `readOperands(_:instructions:)`

```swift
public static func readOperands(_ defintion: OperationDefinition, instructions: Instructions) -> (values: [Int32], count: Int)
```

Decodes bytecode instructions operands into `Int32` representation
- Parameters:
  - defintion: The expected `OperationDefinition`
  - instructions: The instruction bytes
- Returns: The values for the operands by combining the required bytes of each operand

#### Parameters

| Name | Description |
| ---- | ----------- |
| defintion | The expected `OperationDefinition` |
| instructions | The instruction bytes |