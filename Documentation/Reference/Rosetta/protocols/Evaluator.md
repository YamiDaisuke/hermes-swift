**PROTOCOL**

# `Evaluator`

```swift
public protocol Evaluator
```

## Methods
### `eval(program:environment:)`

```swift
static func eval(program: Program, environment: Environment<BaseType>) throws -> BaseType?
```

### `eval(node:environment:)`

```swift
static func eval(node: Node, environment: Environment<BaseType>) throws -> BaseType?
```

### `handleControlTransfer(_:environment:)`

```swift
static func handleControlTransfer(
    _ statement: ControlTransfer,
    environment: Environment<BaseType>
) throws -> BaseType?
```

Evaluates `ControlTransfer` wrapper and generates the corresponding output
- Parameter statement: Some `ControlTransfer` statement wrapper like `return` or
                       `break` statements

#### Parameters

| Name | Description |
| ---- | ----------- |
| statement | Some `ControlTransfer` statement wrapper like `return` or `break` statements |