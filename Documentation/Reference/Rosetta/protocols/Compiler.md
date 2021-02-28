**PROTOCOL**

# `Compiler`

```swift
public protocol Compiler
```

Base Compiler structure for Rosetta VM

## Properties
### `scopes`

```swift
var scopes: [CompilationScope]
```

Keeps the compiled scopes

### `scopeIndex`

```swift
var scopeIndex: Int
```

Marks the current scope being compiled

### `currentScope`

```swift
var currentScope: CompilationScope
```

Returns the current active scope

### `currentInstructions`

```swift
var currentInstructions: Instructions
```

Returns the instructions compiled inside the current scope

### `constants`

```swift
var constants: [BaseType]
```

A pool of the compiled constant values

### `symbolTable`

```swift
var symbolTable: SymbolTable
```

The compiled `SymbolTable`

### `bytecode`

```swift
var bytecode: BytecodeProgram<BaseType>
```

Puts all the compiled values into a single `BytecodeProgram`

## Methods
### `compile(_:)`

```swift
mutating func compile(_ program: Program) throws
```

Traverse a parsed `Program` an creates the corresponding Bytecode
- Parameter program: The program

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |

### `compile(_:)`

```swift
mutating func compile(_ node: Node) throws
```

Traverse a parsed AST an creates the corresponding Bytecode
- Parameter program: The program

#### Parameters

| Name | Description |
| ---- | ----------- |
| program | The program |

### `enterScope()`

```swift
mutating func enterScope()
```

Activates a new compilation scopes

### `leaveScope()`

```swift
mutating func leaveScope() -> Instructions
```

Closes the current compilation scope and returns the compiled instructions
