**PROTOCOL**

# `VMOperations`

```swift
public protocol VMOperations
```

## Methods
### `binaryOperation(lhs:rhs:operation:)`

```swift
func binaryOperation<BaseType>(lhs: BaseType, rhs: BaseType, operation: OpCodes) throws -> BaseType
```

Maps and applies binary operation on the implementing language
- Parameters:
  - lhs: The left hand operand
  - rhs: The right hand operand
- Throws: A language specific error if the values or the operator is not recognized
- Returns: The result of the operation depending on the operands

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The left hand operand |
| rhs | The right hand operand |

### `unaryOperation(rhs:operation:)`

```swift
func unaryOperation<BaseType>(rhs: BaseType, operation: OpCodes) throws -> BaseType
```

Maps and applies unary operation on the implementing language
- Parameters:
  - rhs: The right hand operand
- Throws: A language specific error if the values or the operator is not recognized
- Returns: The result of the operation depending on the operand

#### Parameters

| Name | Description |
| ---- | ----------- |
| rhs | The right hand operand |

### `getLangBool(for:)`

```swift
func getLangBool(for bool: Bool) -> BaseType
```

Gets the language specific representation of a VM boolean value

We could simple use native `Bool` from swift but in this way we keep all
the values independent of the swift language.
- Parameter bool: The swift `Bool` value to wrap
- Returns: A representation of swift `Bool` in the implementing language

#### Parameters

| Name | Description |
| ---- | ----------- |
| bool | The swift `Bool` value to wrap |