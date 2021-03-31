**PROTOCOL**

# `KeyReading`

```swift
public protocol KeyReading
```

Protocol that defines the interface for subscribing
to key events

## Methods
### `subscribe(subscriber:raw:)`

```swift
func subscribe(subscriber: @escaping (KeyEvent) -> Void, raw: ((UInt8) -> Void)?)
```

Subscribes to key events. It blocks the thread until an exit or enter event is delivered.

- Parameter subscriber: Function to notify new key events through.

#### Parameters

| Name | Description |
| ---- | ----------- |
| subscriber | Function to notify new key events through. |