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

`push` function expects an `MArray` parameter and one `Object` parameter
it will return a new `MArray` instance with the same elements as the first parameter
and the second paramter added at the end of the array

### `handleControlTransfer(_:environment:)`

```swift
public static func handleControlTransfer(_ statement: ControlTransfer,
                                         environment: Environment<Object>) throws -> Object?
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| statement | Some `ControlTransfer` statement wrapper like `return` or `break` statements |