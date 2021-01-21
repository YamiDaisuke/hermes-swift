**STRUCT**

# `MString`

```swift
public struct MString: Object, Hashable
```

Monkey Language `String` object, we have
to callit `MString` to avoid colissions with swift
`String`

## Properties
### `type`

```swift
public var type: ObjectType
```

### `value`

```swift
public var value: String
```

### `description`

```swift
public var description: String
```

## Methods
### `+(_:_:)`

```swift
public static func + (lhs: MString, rhs: MString) -> MString
```

Concatenate two `MString` values
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: A new `MString` containing the concatenation of `lhs` and `rhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |

### `+(_:_:)`

```swift
public static func + (lhs: MString, rhs: Object?) -> MString
```

Concatenate two `MString` values
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: A new `MString` containing the concatenation of `lhs` and `rhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |

### `+(_:_:)`

```swift
public static func + (lhs: Object?, rhs: MString) -> MString
```

Concatenate two `MString` values
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: A new `MString` containing the concatenation of `lhs` and `rhs`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |

### `==(_:_:)`

```swift
public static func == (lhs: MString, rhs: MString) -> Boolean
```

Compares two `MString` values
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: `true` if `lhs` is equal to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |

### `!=(_:_:)`

```swift
public static func != (lhs: MString, rhs: MString) -> Boolean
```

Compares two `MString` values
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |

### `==(_:_:)`

```swift
public static func == (lhs: MString, rhs: Object?) -> Boolean
```

Compares an `MString` with other `Object` value
- Parameters:
  - lhs: An `MString` value
  - rhs: An `Object` value
- Returns: `true` if `rhs` is an MString and it is equal to `lhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `Object` value |

### `!=(_:_:)`

```swift
public static func != (lhs: MString, rhs: Object?) -> Boolean
```

Compares an `MString` with other `Object` value
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: `false` if `rhs` is an MString and it is equal to `lhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |

### `==(_:_:)`

```swift
public static func == (lhs: Object, rhs: MString) -> Boolean
```

Compares an `MString` with other `Object` value
- Parameters:
  - lhs: An `Object` value
  - rhs: An `MString` value
- Returns: `true` if `lhs` is an MString and it is equal to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `Object` value |
| rhs | An `MString` value |

### `!=(_:_:)`

```swift
public static func != (lhs: Object?, rhs: MString) -> Boolean
```

Compares an `MString` with other `Object` value
- Parameters:
  - lhs: An `MString` value
  - rhs: An `MString` value
- Returns: `false` if `lhs` is an MString and it is equal to `rhs` otherwise `false`

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | An `MString` value |
| rhs | An `MString` value |