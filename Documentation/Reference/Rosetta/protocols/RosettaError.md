**PROTOCOL**

# `RosettaError`

```swift
public protocol RosettaError: Error, CustomStringConvertible
```

Base error protocol for this library, it includes optional information
to print the script line, column and file where the error occurs if
supported by the language

## Properties
### `message`

```swift
var message: String
```

### `line`

```swift
var line: Int?
```

### `column`

```swift
var column: Int?
```

### `file`

```swift
var file: String?
```
