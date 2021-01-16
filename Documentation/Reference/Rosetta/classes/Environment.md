**CLASS**

# `Environment`

```swift
public class Environment<BaseType>
```

Holds the program variables states
this implementation is prepared to keep
track of outer environments like clousures

## Methods
### `init(outer:)`

```swift
public init(outer: Environment? = nil)
```

Can init this `Environment` with an outer
wrapping `Environment`
- Parameter outer: The outer `Environment`

#### Parameters

| Name | Description |
| ---- | ----------- |
| outer | The outer `Environment` |