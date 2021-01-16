**EXTENSION**

# `Lexer`
```swift
public extension Lexer
```

## Methods
### `readChar()`

```swift
@discardableResult mutating func readChar() -> (current: Character?, next: Character?)
```

Reads the next `Character` from the input and updates the column, line, and
character pointers accordingly

- Returns: The `Character` at the new position and the `Character` as a `Tuple`

### `skip(while:)`

```swift
mutating func skip(while predicate: (Character) -> Bool)
```

Skips characters in the input source while a condition is met, starting from
the `self.currentColumn`. This function might move the current columm and line
pointer accordingly to the number of character skiped

`Lexer.currentColumn`
- Parameters:
  - predicate: An expression that indicates wich characters to skip

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | An expression that indicates wich characters to skip |

### `read(while:)`

```swift
mutating func read(while predicate: (Character) -> Bool) -> String
```

Returns a sub-string from the input starting from `self.currentColumn`
until the first character that not met the condition. This function might move the
current columm and line pointer accordingly to the number of character read

- Parameters:
  - input: The input to take the sub-string from
  - predicate: A predicate function to check if the next character should be taken
               it will recieve the current read `Character`
- Returns: A sub-string that mets the condition from the `while` predicate

#### Parameters

| Name | Description |
| ---- | ----------- |
| input | The input to take the sub-string from |
| predicate | A predicate function to check if the next character should be taken it will recieve the current read `Character` |