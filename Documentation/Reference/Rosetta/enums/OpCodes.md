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

### `sub`

```swift
case sub
```

Subsctract the top two values in the stack

### `mul`

```swift
case mul
```

Multiply the top two values in the stack

### `div`

```swift
case div
```

Divide the top two values in the stack one by the other

### `true`

```swift
case `true`
```

Push `true` into the stack

### `false`

```swift
case `false`
```

Push `false` into the stack

### `equal`

```swift
case equal
```

Performs an equality check

### `notEqual`

```swift
case notEqual
```

Performs an inequality check

### `gt`

```swift
case gt
```

Performs an greater than operation

### `gte`

```swift
case gte
```

Performs an greater than or equal operation

### `minus`

```swift
case minus
```

Performs an unary minus operation, E.G.: `-1, -10`

### `bang`

```swift
case bang
```

Performs a negation operation. E.G: `!true = false`

### `jumpf`

```swift
case jumpf
```

Jumps if the next value in the stack is `false`

### `jump`

```swift
case jump
```

Unconditional jump

### `null`

```swift
case null
```

Push the empty value representation into the stack

### `setGlobal`

```swift
case setGlobal
```

Creates a global bound to a value

### `assignGlobal`

```swift
case assignGlobal
```

Assigns a global bound to a value

### `getGlobal`

```swift
case getGlobal
```

Get the value assigned to a global id

### `array`

```swift
case array
```

Creates an Array from the first "N" elements in the stack
