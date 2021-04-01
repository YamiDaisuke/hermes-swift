**EXTENSION**

# `Instructions`
```swift
public extension Instructions
```

## Properties
### `description`

```swift
var description: String
```

Returns a human readable representations of this set of instructions

## Methods
### `readInt(bytes:startIndex:)`

```swift
func readInt(bytes: Int, startIndex: Int = 0) -> Int32?
```

Converts a number of bytes to `Int32` representation, the taken bytes must be
between 1 and 4, and reprent an int in big endian encoding
- Parameter bytes: The number of bytes, Must be between 1 and 4
- Returns: The `Int32` value

#### Parameters

| Name | Description |
| ---- | ----------- |
| bytes | The number of bytes, Must be between 1 and 4 |