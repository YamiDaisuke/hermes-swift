**PROTOCOL**

# `Decompilable`

```swift
public protocol Decompilable
```

Marks a value that can be converted from a Hermes byte representation

## Methods
### `init(fromBytes:)`

```swift
init(fromBytes bytes: [Byte]) throws
```

### `init(fromBytes:readBytes:)`

```swift
init(fromBytes bytes: [Byte], readBytes: inout Int) throws
```
