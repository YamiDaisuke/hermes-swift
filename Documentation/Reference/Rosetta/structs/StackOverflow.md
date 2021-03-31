**STRUCT**

# `StackOverflow`

```swift
public struct StackOverflow: VMError
```

Throw this error when a program tries to push more than `kStackSize`
elements into the VM stack

## Properties
### `message`

```swift
public var message: String = "Stack overflow"
```

### `line`

```swift
public var line: Int?
```

### `column`

```swift
public var column: Int?
```

### `file`

```swift
public var file: String?
```
