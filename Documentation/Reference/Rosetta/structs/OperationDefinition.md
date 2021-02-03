**STRUCT**

# `OperationDefinition`

```swift
public struct OperationDefinition
```

Metadata `struct` to tell the compiler how the VM instructions are composed

## Properties
### `name`

```swift
public var name: String
```

The human readable name of the operation

### `operandsWidth`

```swift
public var operandsWidth: [Int]
```

The size in bytes of each operand this operation requires
