**PROTOCOL**

# `Compilable`

```swift
public protocol Compilable
```

Marks a value that can be converted into Hermes byte representation

## Methods
### `compile()`

```swift
func compile() -> [Byte]
```

Retunrs a byte array representing this value in the format:
`[<type code bytes:4>,<size bytes: 4>, <value bytes>]`
