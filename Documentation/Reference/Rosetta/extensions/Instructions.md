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

### `intValue`

```swift
var intValue: Int32
```

Converts this slice of instruction bytes to the swift `Int32` representation
the instructions however can be of 1, 2, 3 or 4 bytes of length encoded in
big endian format
