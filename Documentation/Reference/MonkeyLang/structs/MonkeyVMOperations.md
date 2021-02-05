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

Maps binary operation to the right Monkey operation

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