**EXTENSION**

# `Parser`
```swift
public extension Parser
```

## Methods
### `readToken()`

```swift
mutating func readToken()
```

Reads the next `Token` from the associated `Lexer`

### `expectNext(toBe:)`

```swift
mutating func expectNext(toBe type: Token.Kind) throws
```

Checks if the next `Token` in the `Lexer` is of a type, if it is
reads and move the pointers to that `Token` if not, throw an error
- Parameter type: Which type should the next `Token` be
- Throws: `MissingExpected` if the `Token` is not the right type

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | Which type should the next `Token` be |