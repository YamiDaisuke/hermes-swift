//
//  Hash.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 20-01-21.
//

import Foundation

/// Monkey Language `Hash` or Dictionary object
struct Hash: Object {
    var type: ObjectType { "Hash" }

    var pairs: [AnyHashable: Object]

    var description: String {
        "{\(pairs.map { "\"\($0.key)\" : \"\($0.value)\"" }.joined(separator: ", "))}"
    }

    /// Returns the value associated with a key
    /// - Parameter key: Should be one of `Integer`, `Boolean` or `MString`
    /// - Throws: `InvalidHashKey` if the key is not from a supported type
    /// - Returns: The value associated with the `key` or `null` if the `key` is not present in this `Hash`
    func get(_ key: Object) throws -> Object? {
        var value: Object?
        switch key {
        case let integer as Integer:
            value = pairs[integer]
        case let string as MString:
            value = pairs[string]
        case let bool as Boolean:
            value = pairs[bool]
        default:
            throw InvalidHashKey(key.type)
        }

        return value ?? Null.null
    }

    /// Sets a value for key in this `Hash`
    /// - Parameters:
    ///   - key: Should be one of `Integer`, `Boolean` or `MString`
    ///   - value: Any valid `Object` to store
    /// - Throws: `InvalidHashKey` if the key is not from a supported type
    mutating func set(_ key: Object, value: Object) throws {
        switch key {
        case let integer as Integer:
            pairs[integer] = value
        case let string as MString:
            pairs[string] = value
        case let bool as Boolean:
            pairs[bool] = value
        default:
            throw InvalidHashKey(key.type)
        }
    }
}
