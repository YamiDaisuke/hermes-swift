**ENUM**

# `OpCodes`

```swift
public enum OpCodes: OpCode
```

The operation codes supported by the VM

## Cases
### `constant`

```swift
case constant = 0x00
```

Stores a constant value in the cosntants pool

### `add`

```swift
case add = 0x01
```

Adds the top two values in the stack
