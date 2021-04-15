**PROTOCOL**

# `Compilable`

```swift
public protocol Compilable
```

Marks a value that can be converted into Hermes byte representation

## Methods
### `compile()`

```swift
func compile() throws -> [Byte]
```

Retunrs a byte array representing this value in a format like the following:
`[<type code bytes:4>,<size bytes: 4>, <value bytes>]`
Some types might not required an explicit size so this section can be omited
but we always need a type code byte set 
TODO: Work with bits for small memory foot print
