**TYPEALIAS**

# `BuiltinFunction.MonkeyFunction`

```swift
public typealias MonkeyFunction = ([Object]) throws -> Object?
```

Builtin functions will always receive an array of `Object` as arguments
each function is responsible to validate the number and specific parameter
types. The functions must return either nothing or another `Object`