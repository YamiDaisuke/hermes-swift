**STRUCT**

# `MonkeyVMOperations`

```swift
public struct MonkeyVMOperations: VMOperations
```

## Properties
### `languageSignature`

```swift
public var languageSignature: UInt32
```

A magic number used to check if a binary file was generated
by a compiler compatible with this VMOperations.

### `null`

```swift
public var null: VMBaseType
```

Gets the empty value representation for the implementing language

## Methods
### `init()`

```swift
public init()
```

### `decompileConstants(fromBytes:)`

```swift
public func decompileConstants(fromBytes bytes: [Byte]) throws -> [VMBaseType]
```

Takes constants encoded as byte code and converts them to the right value
- Parameter bytes: The encoded bytes
- Throws: A language specific error if a value can't be decompiled
- Returns: An array of values after decompilation

#### Parameters

| Name | Description |
| ---- | ----------- |
| bytes | The encoded bytes |

### `binaryOperation(lhs:rhs:operation:)`

```swift
public func binaryOperation(lhs: VMBaseType?, rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType
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
public func unaryOperation(rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType
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
public func getLangBool(for bool: Bool) -> VMBaseType
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
public func isTruthy(_ value: VMBaseType?) -> Bool
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
public func buildLangArray(from array: [VMBaseType]) -> VMBaseType
```

Takes a native Swift array of the lang base type and converts it to the lang equivalent
- Parameter array: An swift Array

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift Array |

### `buildLangHash(from:)`

```swift
public func buildLangHash(from dictionary: [AnyHashable: VMBaseType]) -> VMBaseType
```

Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
- Parameter array: An swift dictionary

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift dictionary |

### `executeIndexExpression(_:index:)`

```swift
public func executeIndexExpression(_ lhs: VMBaseType, index: VMBaseType) throws -> VMBaseType
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

### `decodeFunction(_:)`

```swift
public func decodeFunction(_ function: VMBaseType) -> VMFunctionDefinition?
```

Extract the VM instructions and locals count from a language especific compiled function
- Parameter function: The supposed function
- Returns: A tuple with the instructions and the locals count or `nil`
           if `function` is not actually a compiled function representation

#### Parameters

| Name | Description |
| ---- | ----------- |
| function | The supposed function |

### `getBuiltinFunction(_:)`

```swift
public func getBuiltinFunction(_ index: Int) -> VMBaseType?
```

Gets a language specific builtin function
- Parameter index: The function index generated by the compiler
- Returns: An object representing the requested function

#### Parameters

| Name | Description |
| ---- | ----------- |
| index | The function index generated by the compiler |

### `executeBuiltinFunction(_:args:)`

```swift
public func executeBuiltinFunction(_ function: VMBaseType, args: [VMBaseType]) throws -> VMBaseType?
```

Should execute a builtin function and
- Parameter function: The function to execute
- Returns: The produced value or nil if `function` is not a valid BuiltIn function

#### Parameters

| Name | Description |
| ---- | ----------- |
| function | The function to execute |