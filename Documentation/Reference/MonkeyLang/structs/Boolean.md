**STRUCT**

# `Boolean`

```swift
public struct Boolean: Object
```

## Properties
### `type`

```swift
public var type: ObjectType
```

### `value`

```swift
public var value: Bool
```

### `description`

```swift
public var description: String
```

## Methods
### `init(_:)`

```swift
public init(_ bool: Bool)
```

Convinience cast a swift `Bool` to one of the
`Bolean` constants

### `init(_:)`

```swift
public init(_ integer: Integer)
```

Convinience cast an `Integer` to one of the
`Bolean` constants. `0` matches to `false`
any other `Integer` maps to `true`

### `!(_:)`

```swift
public static prefix func ! (rhs: Boolean) -> Boolean
```

Negates the value of a `Boolean` value
- Parameter rhs: A `Boolean` value to negate
- Returns: `false` if `rhs` is `true` and `true` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| rhs | A `Boolean` value to negate |

### `==(_:_:)`

```swift
public static func == (lhs: Boolean, rhs: Boolean) -> Boolean
```

Compares two `Boolean` values

- Parameters:
  - lhs: A `Boolean` value
  - rhs: A `Boolean` value
- Returns: `true` if `lhs` is equals to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A `Boolean` value |
| rhs | A `Boolean` value |

### `==(_:_:)`

```swift
public static func == (lhs: Object?, rhs: Boolean) -> Boolean
```

Compares any `Object` agaist a `Boolean` value

- Parameters:
  - lhs: Any instance of `Object`
  - rhs: A `Boolean` value
- Returns: `true` if `rhs` produces the same `Boolean` value as `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | Any instance of `Object` |
| rhs | A `Boolean` value |

### `==(_:_:)`

```swift
public static func == (lhs: Boolean, rhs: Object?) -> Boolean
```

Compares any `Object` agaist a `Boolean` value

- Parameters:
  - lhs: A `Boolean` value
  - rhs: Any instance of `Object`
- Returns: `true` if `lhs` produces the same `Boolean` value as `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A `Boolean` value |
| rhs | Any instance of `Object` |

### `!=(_:_:)`

```swift
public static func != (lhs: Boolean, rhs: Boolean) -> Boolean
```

Compares two `Boolean` values

- Parameters:
  - lhs: A `Boolean` value
  - rhs: A `Boolean` value
- Returns: `false` if `lhs` is equals to `rhs` otherwise `true`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A `Boolean` value |
| rhs | A `Boolean` value |

### `!=(_:_:)`

```swift
public static func != (lhs: Object?, rhs: Boolean) -> Boolean
```

Compares any `Object` agaist a `Boolean` value

- Parameters:
  - lhs: Any instance of `Object`
  - rhs: A `Boolean` value
- Returns: `false` if `lhs` produces the same `Boolean` value as `rhs` otherwise `true`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | Any instance of `Object` |
| rhs | A `Boolean` value |

### `!=(_:_:)`

```swift
public static func != (lhs: Boolean, rhs: Object?) -> Boolean
```

Compares any `Object` agaist a `Boolean` value

- Parameters:
  - lhs: A `Boolean` value
  - rhs: Any instance of `Object`
- Returns: `false` if `rhs` produces the same `Boolean` value as `lhs` otherwise `true`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A `Boolean` value |
| rhs | Any instance of `Object` |