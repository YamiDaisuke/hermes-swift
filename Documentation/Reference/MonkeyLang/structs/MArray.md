**STRUCT**

# `MArray`

```swift
public struct MArray: Object
```

Monkey Language `Array` object, we have
to callit `MArray` to avoid colissions with swift
`Array`

## Properties
### `type`

```swift
public var type: ObjectType
```

### `elements`

```swift
public var elements: [Object]
```

### `description`

```swift
public var description: String
```

## Methods
### `isEquals(other:)`

```swift
public func isEquals(other: Object) -> Bool
```

Compare agaist other object

To be consider equal `other` must be of type `MArray`, contains the same
number of element and each value must be equal to the corresponding
value in `other`
- Parameter other: The other `Object`
- Returns: `true` if `self` is equals to `other`

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | The other `Object` |