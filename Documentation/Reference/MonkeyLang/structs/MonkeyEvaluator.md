**STRUCT**

# `MonkeyEvaluator`

```swift
public struct MonkeyEvaluator: Evaluator
```

## Methods
### `eval(node:environment:)`

```swift
public static func eval(node: Node, environment: Environment<Object>) throws -> Object?
```

`len` function expects a single `MString` parameter and
will return the number of characters in that `MString` as `Integer`

### `handleControlTransfer(_:environment:)`

```swift
public static func handleControlTransfer(_ statement: ControlTransfer,
                                         environment: Environment<Object>) throws -> Object?
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| statement | Some `ControlTransfer` statement wrapper like `return` or `break` statements |