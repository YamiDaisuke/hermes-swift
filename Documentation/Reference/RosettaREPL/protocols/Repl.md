**PROTOCOL**

# `Repl`

```swift
public protocol Repl
```

Base protocl for REPL tool implementations

## Properties
### `welcomeMessage`

```swift
var welcomeMessage: String
```

A friendly welcome message for our users

### `prompt`

```swift
var prompt: String
```

The prompt sequence to read input

### `controller`

```swift
var controller: TerminalController?
```

We use `TerminalController` to manipulate the terminal input

### `stack`

```swift
var stack: [String]
```

Store here the previous comands so the user can navigate his history

## Methods
### `run()`

```swift
mutating func run()
```

Runs the REPL

### `readInput()`

```swift
func readInput() -> String
```

Handle the user input
- Returns: The input string

### `printError(_:)`

```swift
func printError(_ error: Error)
```

Prints friendly error representations
- Parameter error: The `Error` to print

#### Parameters

| Name | Description |
| ---- | ----------- |
| error | The `Error` to print |