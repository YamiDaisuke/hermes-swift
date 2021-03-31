**STRUCT**

# `MonkeyC`

```swift
public struct MonkeyC: Compiler
```

Monkey Lang compiler for the Rosetta VM

## Properties
### `scopes`

```swift
public var scopes = [CompilationScope()]
```

### `scopeIndex`

```swift
public var scopeIndex: Int = 0
```

### `constants`

```swift
public var constants: [VMBaseType] = []
```

### `symbolTable`

```swift
public var symbolTable: SymbolTable
```

## Methods
### `init()`

```swift
public init()
```

### `init(withSymbolTable:)`

```swift
public init(withSymbolTable table: SymbolTable)
```

Creates a compiler instance with an existing `SymbolTable`
- Parameter table: The existing table

#### Parameters

| Name | Description |
| ---- | ----------- |
| table | The existing table |

### `compile(_:)`

```swift
public mutating func compile(_ program: Program) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |

### `compile(_:)`

```swift
public mutating func compile(_ node: Node) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |