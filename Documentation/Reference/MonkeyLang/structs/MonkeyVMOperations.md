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

### `add(lhs:rhs:)`

```swift
public func add<BaseType>(lhs: BaseType, rhs: BaseType) throws -> BaseType
```

Apply addition operation to two supported objects

Supported variations are:
```
Integer + Integer
String + Object // Using the Object String representation
```
- Parameters:
  - lhs: The left hand operand
  - rhs: The right hand operand
- Throws: `InvalidInfixExpression` if any of the operands is not supported
- Returns: The result of the operation depending on the operands

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The left hand operand |
| rhs | The right hand operand |