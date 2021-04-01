**CLASS**

# `CompilationScope`

```swift
public class CompilationScope
```

Holds an list of compiled instructions for one scope like a function or a closure

## Properties
### `lastInstruction`

```swift
public var lastInstruction: EmittedInstruction?
```

Holds the last emitted instruction

### `prevInstruction`

```swift
public var prevInstruction: EmittedInstruction?
```

Holds the previous emitted instruction

## Methods
### `init()`

```swift
public init()
```

### `addInstruction(_:)`

```swift
public func addInstruction(_ instruction: Instructions) -> Int
```

Stores a compiled instruction
- Parameter instruction: The instruction to store
- Returns: The starting index of this instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| instruction | The instruction to store |

### `removeLast(if:)`

```swift
public func removeLast(if predicate: ((EmittedInstruction) -> Bool)? = nil)
```

Removes the las instruction from the emmited instruction with an optional predicate
- Parameter predicate: An optional predicate to choose whether or not to remove the last instruction
                       if no predicate is supplied the instruction is removed

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | An optional predicate to choose whether or not to remove the last instruction if no predicate is supplied the instruction is removed |

### `replaceInstructionAt(_:with:)`

```swift
public func replaceInstructionAt(_ position: Int, with newInstruction: Instructions)
```

Replace instruction bytes starting at `position` with `newInstruction`
- Parameters:
  - position: The starting position to replace
  - newInstruction: The new instruction bytes

#### Parameters

| Name | Description |
| ---- | ----------- |
| position | The starting position to replace |
| newInstruction | The new instruction bytes |