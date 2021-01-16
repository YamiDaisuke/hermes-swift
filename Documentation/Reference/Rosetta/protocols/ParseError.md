**PROTOCOL**

# `ParseError`

```swift
public protocol ParseError: Error, CustomStringConvertible
```

All Parsing errors should implement this protocol

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
