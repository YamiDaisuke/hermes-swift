**ENUM**

# `SemVersionCompatibility`

```swift
public enum SemVersionCompatibility
```

Tells at which level two semantic version numbers should match to
be considered compatible

## Cases
### `exact`

```swift
case exact
```

Requires all three values to match

### `minor`

```swift
case minor
```

Requires only major version to match. Minor and patch should be greater than or equal

### `patch`

```swift
case patch
```

Requires major and minor version to match. Patch should be greater than or equal
