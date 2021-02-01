**STRUCT**

# `Null`

```swift
public struct Null: Object
```

Represents an empty value

## Properties
### `type`

```swift
public var type: ObjectType
```

### `description`

```swift
public var description: String
```

## Methods
### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | Another Object instance |

### `equals(lhs:rhs:)`

```swift
public static func equals(lhs: Object?, rhs: Null) -> Boolean
```

Compares any `Object` agaist the `Null` value

- Parameters:
  - lhs: Any instance of `Object`
  - rhs: The `Null` value
- Returns: `true` if `lhs` is `Null`, `false` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | Any instance of `Object` |
| rhs | The `Null` value |

### `notEquals(lhs:rhs:)`

```swift
public static func notEquals(lhs: Object?, rhs: Null) -> Boolean
```

Compares any `Object` agaist the `Null` value

- Parameters:
  - lhs: Any instance of `Object`
  - rhs: The `Null` value
- Returns: `false` if `lhs` is `Null`, `true` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | Any instance of `Object` |
| rhs | The `Null` value |

### `==(_:_:)`

```swift
public static func == (lhs: Object?, rhs: Null) -> Boolean
```

Compares any `Object` agaist the `Null` value

- Parameters:
  - lhs: Any instance of `Object`
  - rhs: The `Null` value
- Returns: `true` if `lhs` is `Null`, `false` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | Any instance of `Object` |
| rhs | The `Null` value |

### `==(_:_:)`

```swift
public static func == (lhs: Null, rhs: Object?) -> Boolean
```

Compares any `Null` agaist an `Object` value

- Parameters:
  - lhs: The `Null` value
  - rhs: Any instance of `Object`
- Returns: `true` if `rhs` is `Null`, `false` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The `Null` value |
| rhs | Any instance of `Object` |

### `!=(_:_:)`

```swift
public static func != (lhs: Object?, rhs: Null) -> Boolean
```

Compares any `Object` agaist the `Null` value

- Parameters:
  - lhs: Any instance of `Object`
  - rhs: The `Null` value
- Returns: `false` if `lhs` is `Null`, `true` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | Any instance of `Object` |
| rhs | The `Null` value |

### `!=(_:_:)`

```swift
public static func != (lhs: Null, rhs: Object?) -> Boolean
```

Compares any `Object` agaist the `Null` value

- Parameters:
  - lhs: The `Null` value
  - rhs: Any instance of `Object`
- Returns: `false` if `rhs` is `Null`, `true` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The `Null` value |
| rhs | Any instance of `Object` |