**PROTOCOL**

# `VMOperations`

```swift
public protocol VMOperations
```

## Properties
### `null`

```swift
var null: BaseType
```

Gets the empty value representation for the implementing language

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

### `isTruthy(_:)`

```swift
func isTruthy(_ value: BaseType?) -> Bool
```

Check if a value of the implemeting language is considered an equivalent of `true`
- Parameter value: The value to check
- Returns: `true` if the given value is considered truthy in the implementing language

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value to check |

### `buildLangArray(from:)`

```swift
func buildLangArray(from array: [BaseType]) -> BaseType
```

Takes a native Swift array of the lang base type and converts it to the lang equivalent
- Parameter array: An swift Array

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift Array |

### `buildLangHash(from:)`

```swift
func buildLangHash(from array: [AnyHashable: BaseType]) -> BaseType
```

Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
- Parameter array: An swift dictionary

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift dictionary |

### `executeIndexExpression(_:index:)`

```swift
func executeIndexExpression(_ lhs: BaseType, index: BaseType) throws -> BaseType
```

Performs an language index (A.K.A subscript) operation in the form of: `<expression>[<expression>]`
- Parameters:
  - lhs: The value to be indexed
  - index: The index to apply

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The value to be indexed |
| index | The index to apply |

### `decodeFunction(_:)`

```swift
func decodeFunction(_ function: BaseType) -> (instructions: Instructions, locals: Int, parameters: Int)?
```

Extract the VM instructions and locals count from a language especific compiled function
- Parameter function: The supposed function
- Returns: A tuple with the instructions and the locals count or `nil`
           if `function` is not actually a compiled function representation

#### Parameters

| Name | Description |
| ---- | ----------- |
| function | The supposed function |