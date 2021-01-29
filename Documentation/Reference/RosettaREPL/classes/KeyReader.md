**CLASS**

# `KeyReader`

```swift
public class KeyReader: KeyReading
```

## Methods
### `init()`

```swift
public init()
```

### `subscribe(subscriber:)`

```swift
public func subscribe(subscriber: @escaping (KeyEvent) -> Void)
```

Subscribes to key events. It blocks the thread until an exit or enter event is delivered.

- Parameter subscriber: Function to notify new key events through.

#### Parameters

| Name | Description |
| ---- | ----------- |
| subscriber | Function to notify new key events through. |