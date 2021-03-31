**PROTOCOL**

# `Object`

```swift
public protocol Object: VMBaseType
```

Base Type for all variables inside Monkey Language
think of this like the `Any` type of swift or `object`
type in C#

## Properties
### `type`

```swift
var type: ObjectType
```

## Methods
### `isEquals(other:)`

```swift
func isEquals(other: Object) -> Bool
```

Compare agaist other object

To avoid problems with the use of `Self` when implementing
`Equatable` we use this approach.
- Parameter other: Another Object instance

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | Another Object instance |