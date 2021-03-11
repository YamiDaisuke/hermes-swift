**CLASS**

# `SymbolTable`

```swift
public class SymbolTable: NSObject
```

Holds a list of compiled symbols

## Properties
### `totalDefinitions`

```swift
public var totalDefinitions: Int
```

How many symbols this table contains

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