**PROTOCOL**

# `InfixParser`

```swift
public protocol InfixParser
```

Parse expression construct with operator infixing
<expression> <infix operator> <expression>

## Methods
### `parse(_:lhs:)`

```swift
func parse<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser
```
