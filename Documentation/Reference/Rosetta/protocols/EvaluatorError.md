**PROTOCOL**

# `EvaluatorError`

```swift
public protocol EvaluatorError: Error, CustomStringConvertible
```

All Evaluation errors should implement this protocol

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
