**EXTENSION**

# `TerminalController`
```swift
public extension TerminalController
```

## Methods
### `clearToRight()`

```swift
func clearToRight()
```

Clears all characters to the right of the cursor position

### `clear()`

```swift
func clear()
```

Clear the entire terminal an move the cursor to the upper left corner

### `moveLeft(steps:)`

```swift
func moveLeft(steps: Int = 1)
```

Moves the cursor to the left
- Parameter steps: Number of positions to move. Default 1

#### Parameters

| Name | Description |
| ---- | ----------- |
| steps | Number of positions to move. Default 1 |

### `moveRight(steps:)`

```swift
func moveRight(steps: Int = 1)
```

Moves the cursor to the right
- Parameter steps: Number of positions to move. Default 1

#### Parameters

| Name | Description |
| ---- | ----------- |
| steps | Number of positions to move. Default 1 |

### `printError(_:)`

```swift
static func printError(_ error: Any)
```

Calls print function wrapped in red color modifier for terminal output
- Parameter error: The object to print

#### Parameters

| Name | Description |
| ---- | ----------- |
| error | The object to print |