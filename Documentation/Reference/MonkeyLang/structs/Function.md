**STRUCT**

# `Function`

```swift
public struct Function: Object
```

Represents any function from the MonkeyLanguage
`Function` instances can be called and executed
at any point by having an identifier pointing to it.
Or by explicity calling it at the moment of declaration

## Properties
### `type`

```swift
public var type: ObjectType
```

### `parameters`

```swift
public var parameters: [String]
```

### `environment`

```swift
public var environment: Environment<Object>
```

This will be a reference to the function outer environment

### `description`

```swift
public var description: String
```
