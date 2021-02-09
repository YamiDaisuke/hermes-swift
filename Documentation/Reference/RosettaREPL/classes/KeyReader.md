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

### `abort()`

```swift
public func abort()
```

Call this  function when you want to abort the current reading session
and restore the terminal raw mode

### `subscribe(subscriber:raw:)`

```swift
public func subscribe(subscriber: @escaping (KeyEvent) -> Void, raw: ((UInt8) -> Void)? = nil)
```

Subscribes to key events. It blocks the thread until an exit or enter event is delivered.

- Parameter subscriber: Function to notify new key events through.

#### Parameters

| Name | Description |
| ---- | ----------- |
| subscriber | Function to notify new key events through. |