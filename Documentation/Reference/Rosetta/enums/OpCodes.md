**ENUM**

# `OpCodes`

```swift
public enum OpCodes: OpCode
```

The operation codes supported by the VM

## Cases
### `constant`

```swift
case constant
```

Stores a constant value in the cosntants pool

### `pop`

```swift
case pop
```

Pops the value at top of the stack

### `add`

```swift
case add
```

Adds the top two values in the stack
