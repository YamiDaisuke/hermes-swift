**CLASS**

# `Frame`

```swift
public class Frame
```

Represents the current call frame inside the VM

## Methods
### `init(_:basePointer:)`

```swift
public init(_ closure: Closure, basePointer: Int = 0)
```

Creates a new frame with a list of instructions
- Parameter instructions: The instructions

#### Parameters

| Name | Description |
| ---- | ----------- |
| instructions | The instructions |