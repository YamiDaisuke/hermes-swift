**EXTENSION**

# `Repl`
```swift
public extension Repl
```

## Methods
### `readInput()`

```swift
func readInput() -> String
```

Handle the user input

- Currently the input can be edited by using left and right arrow keys,
up and down keys allow navigation in the input stack.
- Backspace and delete works as expected.
- ctrl+L will clear the terminal and the current typed command
**Only tested on macOS iTerm**
- Returns: The input string
