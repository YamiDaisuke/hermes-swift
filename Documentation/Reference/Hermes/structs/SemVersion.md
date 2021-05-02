**STRUCT**

# `SemVersion`

```swift
public struct SemVersion: CustomStringConvertible
```

A struct to esly hold semantic version values. E.G.: 1.1.1

## Properties
### `major`

```swift
public var major: UInt16
```

### `minor`

```swift
public var minor: UInt16
```

### `patch`

```swift
public var patch: UInt16
```

### `bytes`

```swift
public var bytes: [Byte]
```

Returns the  byte representation of this version

### `description`

```swift
public var description: String
```

## Methods
### `init(major:minor:patch:)`

```swift
public init(major: UInt16, minor: UInt16, patch: UInt16)
```

### `init(_:)`

```swift
public init(_ bytes: [Byte])
```

Reads the value from a byte array of at lest 6 bytes

### `isCompatible(_:component:)`

```swift
public func isCompatible(_ other: SemVersion, component: SemVersionCompatibility) -> Bool
```

Determinates if another version is compatible with this one
- Parameters:
  - other: The other version to compare
  - component: At which level this two version must be compatible
- Returns: `true` if `other` is compatible with `self`

#### Parameters

| Name | Description |
| ---- | ----------- |
| other | The other version to compare |
| component | At which level this two version must be compatible |