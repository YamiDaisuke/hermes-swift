**PROTOCOL**

# `VMFunctionDefinition`

```swift
public protocol VMFunctionDefinition
```

Language agnostic representation of functions so they can be
executed by the VM

## Properties
### `instructions`

```swift
var instructions: Instructions
```

Compiled intructions

### `localsCount`

```swift
var localsCount: Int
```

Number of declared local variables and constants

### `parameterCount`

```swift
var parameterCount: Int
```

Number of expected parameters
