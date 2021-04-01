**STRUCT**

# `Token`

```swift
public struct Token
```

Represents any token within a code block

## Properties
### `type`

```swift
public let type: Token.Kind
```

### `literal`

```swift
public let literal: String
```

### `file`

```swift
public var file: String?
```

### `line`

```swift
public var line: Int?
```

### `column`

```swift
public var column: Int?
```

## Methods
### `init(type:literal:file:line:column:)`

```swift
public init(type: Token.Kind, literal: String, file: String? = nil, line: Int? = nil, column: Int? = nil)
```
