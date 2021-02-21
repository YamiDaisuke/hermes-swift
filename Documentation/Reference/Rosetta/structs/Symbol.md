**STRUCT**

# `Symbol`

```swift
public struct Symbol
```

Abstract representation of a compiled symbol
can be used to generate debug symbols

## Properties
### `name`

```swift
public var name: String
```

The identifer for the symbol

### `scope`

```swift
public var scope: Scope
```

Which scope this symbol belongs to

### `index`

```swift
public var index: Int
```

The index of the symbol inside the value table

## Methods
### `init(name:scope:index:)`

```swift
public init(name: String, scope: Scope, index: Int)
```
