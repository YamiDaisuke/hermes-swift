**STRUCT**

# `Integer`

```swift
public struct Integer: Object, Hashable
```

An Integer value in Monkey

## Properties
### `type`

```swift
public var type: ObjectType
```

### `value`

```swift
public var value: Int32
```

### `description`

```swift
public var description: String
```

## Methods
### `init(_:)`

```swift
public init(_ value: Int32)
```

### `init(_:)`

```swift
public init(_ value: Int)
```

### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | Another Object instance |

### `-(_:)`

```swift
public static prefix func - (rhs: Integer) -> Integer
```

Returns the result of multiply the value of this `Integer` by -1
- Parameter rhs: The `Integer`value
- Returns: Negative `rhs` if it is Positive and Positve `rhs` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| rhs | The `Integer`value |

### `+(_:_:)`

```swift
public static func + (lhs: Integer, rhs: Integer) -> Integer
```

Adds two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: A new `Integer` containing the sum of `lhs` and `rhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `-(_:_:)`

```swift
public static func - (lhs: Integer, rhs: Integer) -> Integer
```

Substract two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: A new `Integer` containing the substraction of `rhs` from `lhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `*(_:_:)`

```swift
public static func * (lhs: Integer, rhs: Integer) -> Integer
```

Multiply two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: A new `Integer` containing the product of `lhs` times `rhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `/(_:_:)`

```swift
public static func / (lhs: Integer, rhs: Integer) -> Integer
```

Adds two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: A new `Integer` containing the division of `lhs` divided by `rhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `>(_:_:)`

```swift
public static func > (lhs: Integer, rhs: Integer) -> Boolean
```

Compares two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: `true` if `lhs` is greater than `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `>=(_:_:)`

```swift
public static func >= (lhs: Integer, rhs: Integer) -> Boolean
```

Compares two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: `true` if `lhs` is greater than or equals to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `<(_:_:)`

```swift
public static func < (lhs: Integer, rhs: Integer) -> Boolean
```

Compares two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: `true` if `lhs` is lower than `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `<=(_:_:)`

```swift
public static func <= (lhs: Integer, rhs: Integer) -> Boolean
```

Compares two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: `true` if `lhs` is lower than or equals to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `==(_:_:)`

```swift
public static func == (lhs: Integer, rhs: Integer) -> Boolean
```

Compares two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: `true` if `lhs` is equal to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |

### `!=(_:_:)`

```swift
public static func != (lhs: Integer, rhs: Integer) -> Boolean
```

Compares two `Integer` values
- Parameters:
  - lhs: An `Integer` value
  - rhs: An `Integer` value
- Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Integer` value |
| rhs | An `Integer` value |