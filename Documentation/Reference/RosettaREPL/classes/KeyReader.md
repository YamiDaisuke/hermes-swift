**CLASS**

# `KeyReader`

```swift
public class KeyReader
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

### `subscribe(subscriber:)`

```swift
public func subscribe(subscriber: @escaping (KeyEvent) -> Bool)
```

Subscribes to key events. It blocks the thread the subscriber tells the reader to stop

- Parameter subscriber: Function to notify new key events through. Should return `false` to stop the
                        reading loop

#### Parameters

| Name | Description |
| ---- | ----------- |
| subscriber | Function to notify new key events through. Should return `false` to stop the reading loop |