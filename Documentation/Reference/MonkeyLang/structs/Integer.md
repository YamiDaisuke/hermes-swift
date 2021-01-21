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
public var value: Int
```

### `description`

```swift
public var description: String
```

## Methods
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