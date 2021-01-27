**CLASS**

# `StreamReader`

```swift
public class StreamReader
```

Reads a file line by line to keep it efficient
taken from: https://gist.github.com/sooop/a2b110f8eebdf904d0664ed171bcd7a2

## Methods
### `init(url:delimeter:encoding:chunkSize:)`

```swift
public init?(url: URL, delimeter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096)
```

### `deinit`

```swift
deinit
```

### `rewind()`

```swift
public func rewind()
```

### `nextLine()`

```swift
public func nextLine() -> String?
```
