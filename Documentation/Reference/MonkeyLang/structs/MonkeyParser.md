**STRUCT**

# `MonkeyParser`

```swift
public struct MonkeyParser: Parser
```

## Properties
### `lexer`

```swift
public var lexer: Lexer
```

### `currentToken`

```swift
public var currentToken: Token?
```

### `currentPrecendece`

```swift
public var currentPrecendece: Int
```

### `nextToken`

```swift
public var nextToken: Token?
```

### `nextPrecendece`

```swift
public var nextPrecendece: Int
```

### `prefixParser`

```swift
public var prefixParser: PrefixParser
```

### `infixParser`

```swift
public var infixParser: InfixParser
```

## Methods
### `init(lexer:)`

```swift
public init(lexer: Lexer)
```

### `parseProgram()`

```swift
public mutating func parseProgram() throws -> Program?
```

### `parseStatement()`

```swift
public mutating func parseStatement() throws -> Statement?
```

### `parseExpression(withPrecedence:)`

```swift
public mutating func parseExpression(withPrecedence precedence: Int) throws -> Expression?
```
