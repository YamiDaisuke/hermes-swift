**STRUCT**

# `EmittedInstruction`

```swift
public struct EmittedInstruction
```

Abstract representation of a compiler emmited instruction

## Properties
### `code`

```swift
public var code: OpCodes
```

The emited operation code

### `position`

```swift
public var position: Int
```

The position of this instrucction inside the instructions

## Methods
### `init(_:position:)`

```swift
public init(_ code: OpCodes, position: Int)
```
