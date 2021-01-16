**PROTOCOL**

# `Parser`

```swift
public protocol Parser
```

Base protocol for a language `Parser`

## Properties
### `lexer`

```swift
var lexer: Lexer
```

### `currentToken`

```swift
var currentToken: Token?
```

### `currentPrecendece`

```swift
var currentPrecendece: Int
```

### `nextToken`

```swift
var nextToken: Token?
```

### `nextPrecendece`

```swift
var nextPrecendece: Int
```

### `prefixParser`

```swift
var prefixParser: PrefixParser
```

Will hold helper functions thar will be used to parse expression
components based on how they are used

### `infixParser`

```swift
var infixParser: InfixParser
```

## Methods
### `readToken()`

```swift
mutating func readToken()
```

### `parseProgram()`

```swift
mutating func parseProgram() throws -> Program?
```

### `parseStatement()`

```swift
mutating func parseStatement() throws -> Statement?
```

### `parseExpression(withPrecedence:)`

```swift
mutating func parseExpression(withPrecedence precedence: Int) throws -> Expression?
```
