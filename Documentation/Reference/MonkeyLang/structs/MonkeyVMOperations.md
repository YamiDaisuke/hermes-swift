**STRUCT**

# `MonkeyVMOperations`

```swift
public struct MonkeyVMOperations: VMOperations
```

## Properties
### `null`

```swift
public var null: BaseType
```

Gets the empty value representation for the implementing language

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

### `unaryOperation(rhs:operation:)`

```swift
public func unaryOperation<BaseType>(rhs: BaseType, operation: OpCodes) throws -> BaseType
```

Maps and applies unary operation to the right Monkey operation

Supported variations are:
```
!Object
-Integer
```
- Parameters:
  - rhs: The right hand operand
- Throws: `InvalidPrefixExpression` if any of the operands is not supported.
          `UnknownOperator` if the bytecode operator doesn't match a monkey operation
- Returns: The result of the operation depending on the operands

#### Parameters

| Name | Description |
| ---- | ----------- |
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

### `isTruthy(_:)`

```swift
public func isTruthy(_ value: BaseType?) -> Bool
```

Check if an `Object` is considered truthy
- Parameter value: The value to check
- Returns: `true` if the given value is considered truthy

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value to check |

### `buildLangArray(from:)`

```swift
public func buildLangArray(from array: [Object]) -> Object
```

Takes a native Swift array of the lang base type and converts it to the lang equivalent
- Parameter array: An swift Array

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift Array |

### `buildLangHash(from:)`

```swift
public func buildLangHash(from dictionary: [AnyHashable: Object]) -> Object
```

Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
- Parameter array: An swift dictionary

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift dictionary |

### `executeIndexExpression(_:index:)`

```swift
public func executeIndexExpression(_ lhs: BaseType, index: BaseType) throws -> BaseType
```

Performs an language index (A.K.A subscript) operation in the form of: `<expression>[<expression>]`

Supported options are:
```
<Array>[<Integer>]
<Hash>[<Integer|String>]
```
- Parameters:
  - lhs: An `MArray`  or `Hash`
  - index: The value to use as index
- Throws: `IndexNotSupported` if `lhs` is not the right type.
          `InvalidArrayIndex` or `InvalidHashKey` if  `index` can't be applied to `lhs`
- Returns: The value associated wiith the `index` or `null`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MArray`  or `Hash` |
| index | The value to use as index |