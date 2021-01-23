**CLASS**

# `Environment`

```swift
public class Environment<BaseType>
```

Holds the program variables states
this implementation is prepared to keep
track of outer environments like clousures

## Methods
### `init(outer:)`

```swift
public init(outer: Environment? = nil)
```

Can init this `Environment` with an outer
wrapping `Environment`
- Parameter outer: The outer `Environment`

#### Parameters

| Name | Description |
| ---- | ----------- |
| outer | The outer `Environment` |

### `get(_:)`

```swift
public func get(_ key: String) -> BaseType?
```

Returns the associated value of a variable
giving priority to the current scope
- Parameter key: The identifier for this variable or constant
- Returns: The associated value or `nil` if the variable or constant doesn't exits

#### Parameters

| Name | Description |
| ---- | ----------- |
| key | The identifier for this variable or constant |

### `create(_:value:type:)`

```swift
public func create(_ key: String, value: BaseType?, type: VariableType = .let) throws
```

Creates a new variable or constant in this environment
- Parameters:
  - key: The identifier for this variable or constant
  - value: The value to associate
  - type: Wheter this is a variable or a constant. Default `let` I.E.: constant
- Throws: `RedeclarationError` if the variable already exists

#### Parameters

| Name | Description |
| ---- | ----------- |
| key | The identifier for this variable or constant |
| value | The value to associate |
| type | Wheter this is a variable or a constant. Default `let` I.E.: constant |

### `set(_:value:type:)`

```swift
public func set(_ key: String, value: BaseType?, type: VariableType = .let) throws
```

Sets a new variable or constant value.

if the variable exists within the current scope that  varaible is assigned
if the variable does not exists in the current scope but exists in the outer
one that variable is assiged.
If the `key` references an existing constant an error is thrown
- Parameters:
  - key: The identifier for this variable or constant
  - value: The value to associate
  - type: Wheter this is a variable or a constant. Default `let` I.E.: constant
- Throws: `AssignConstantError` If the `key` references an existing constant
          `ReferenceError` if the `key` doesn't exists

#### Parameters

| Name | Description |
| ---- | ----------- |
| key | The identifier for this variable or constant |
| value | The value to associate |
| type | Wheter this is a variable or a constant. Default `let` I.E.: constant |

### `contains(key:includeOuter:)`

```swift
public func contains(key: String, includeOuter: Bool = false) -> Bool
```

Checks if `key` exists in this `Environment`. By default only checks
the inner context

- Parameters:
  - key: The identifier for the variable or constant
  - includeOuter: Wheter to check the outer context or not. By default `false`
- Returns: `true` if there is a value stored `false` otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| key | The identifier for the variable or constant |
| includeOuter | Wheter to check the outer context or not. By default `false` |