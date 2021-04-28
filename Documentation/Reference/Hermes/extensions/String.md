**EXTENSION**

# `String`
```swift
extension String
```

## Properties
### `bytes`

```swift
public var bytes: [Byte]
```

Utility to get UTF8 bytes from a string

### `isLetter`

```swift
public var isLetter: Bool
```

Returns `true` if this `String` contains only characters consider
a valid letter for identifiers

## Methods
### `=~(_:_:)`

```swift
static func =~ (lhs: String, rhs: String) -> Bool
```

Compares a `String` against another string containing a regular expression

- Parameters:
  - lhs: The `String` to match
  - rhs: A `String` containing a valid regular expression to match againts `lhs`
- Returns: `true` if `lhs` matches the regular expression in `rhs` or `false` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The `String` to match |
| rhs | A `String` containing a valid regular expression to match againts `lhs` |