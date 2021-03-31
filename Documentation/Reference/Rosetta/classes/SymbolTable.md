**CLASS**

# `SymbolTable`

```swift
public class SymbolTable: NSObject
```

Holds a list of compiled symbols

## Properties
### `totalDefinitions`

```swift
public var totalDefinitions: Int = 0
```

How many symbols this table contains

### `freeSymbols`

```swift
public var freeSymbols: [Symbol] = []
```

Free values captured by closure

### `description`

```swift
public override var description: String
```

## Methods
### `init()`

```swift
public override init()
```

Default init

### `init(_:)`

```swift
public init(_ outer: SymbolTable)
```

Creates a new `SymbolTable` from a base outer scope

### `define(_:type:)`

```swift
public func define(_ name: String, type: VariableType = .let) throws -> Symbol
```

Defines a new symbol with the given name
- Parameters:
    - name: The name/identifier of the symbol
    - type: Define if this symbol is a constant or a variable
- Throws: `RedeclarationError` if `name` is  already in this table
- Returns: The newly created symbol

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name/identifier of the symbol |
| type | Define if this symbol is a constant or a variable |

### `defineBuiltin(_:index:)`

```swift
public func defineBuiltin(_ name: String, index: Int) throws -> Symbol
```

Defines a new builtin symbol with the given name
- Parameters:
    - name: The name/identifier of the symbol
    - index: The value index in this table
- Throws: `RedeclarationError` if `name` is  already in this table
- Returns: The newly created symbol

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name/identifier of the symbol |
| index | The value index in this table |

### `defineFree(from:)`

```swift
public func defineFree(from original: Symbol) throws -> Symbol
```

Defines a new free symbol with the given name
- Parameters:
    - original: A symbol to convert into a free variable for the closure
- Throws: `RedeclarationError` if `name` is  already in this table
- Returns: The newly created symbol

#### Parameters

| Name | Description |
| ---- | ----------- |
| original | A symbol to convert into a free variable for the closure |

### `defineFunctionName(_:)`

```swift
public func defineFunctionName(_ name: String) throws -> Symbol
```

Defines the function name in the current scope this only applies if the
current function is being assigned into a named variable or constant
- Parameters:
    - name: The name/identifier of the function
- Throws: `RedeclarationError` if `name` is  already in this table
- Returns: The newly created symbol

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name/identifier of the function |

### `resolve(_:)`

```swift
public func resolve(_ name: String) throws -> Symbol
```

Resolves a name/identifier into a symbol
- Parameter name: The name/identifier to resolve
- Throws: `CantResolveName` if `name` is not registerd in this table
- Returns: The `Symbol` assigned to `name`

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name/identifier to resolve |