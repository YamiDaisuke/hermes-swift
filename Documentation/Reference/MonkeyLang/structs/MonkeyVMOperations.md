**STRUCT**

# `MonkeyVMOperations`

```swift
public struct MonkeyVMOperations: VMOperations
```

## Methods
### `init()`

```swift
public init()
```

### `binaryOperation(lhs:rhs:operation:)`

```swift
public func binaryOperation<BaseType>(lhs: BaseType, rhs: BaseType, operation: OpCodes) throws -> BaseType
```

Maps and applies binary operation to the right Monkey operation

Supported variations are:
```
Integer + Integer
String + Object // Using the Object String representation
Integer - Integer
Integer * Integer
Integer / Integer
```
- Parameters:
  - lhs: The left hand operand
  - rhs: The right hand operand
- Throws: `InvalidInfixExpression` if any of the operands is not supported.
          `UnknownOperator` if the bytecode operator doesn't match a monkey operation
- Returns: The result of the operation depending on the operands

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The left hand operand |
| rhs | The right hand operand |

### `getLangBool(for:)`

```swift
public func getLangBool(for bool: Bool) -> BaseType
```

Gets the language specific representation of a VM boolean value

We could simple use native `Bool` from swift but in this way we keep all
the values independent of the swift language.
- Parameter bool: The swift `Bool` value to wrap
- Returns: A representation of swift `Bool` in Monkey language which will be `Boolean`

#### Parameters

| Name | Description |
| ---- | ----------- |
| bool | The swift `Bool` value to wrap |