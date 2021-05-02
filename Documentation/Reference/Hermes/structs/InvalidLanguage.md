**STRUCT**

# `InvalidLanguage`

```swift
public struct InvalidLanguage: VMError
```

Throw this error when the VM is trying to execute a binary file
that it is targeting a different language than the current VM instance

## Properties
### `message`

```swift
public var message: String
```

### `line`

```swift
public var line: Int?
```

### `column`

```swift
public var column: Int?
```

### `file`

```swift
public var file: String?
```

## Methods
### `init(_:line:column:file:)`

```swift
public init(_ filePath: URL, line: Int? = nil, column: Int? = nil, file: String? = nil)
```
