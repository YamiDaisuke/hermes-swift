**PROTOCOL**

# `PrefixParser`

```swift
public protocol PrefixParser
```

Parse expression construct with operator prefixing
<prefix operator><expression>

## Methods
### `parse(_:)`

```swift
func parse<P>(_ parser: inout P) throws -> Expression? where P: Parser
```
