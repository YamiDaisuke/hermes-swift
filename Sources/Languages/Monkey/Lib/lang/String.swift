//
//  String.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation
import Rosetta

/// Monkey Language `String` object, we have
/// to callit `MString` to avoid colissions with swift
/// `String`
public struct MString: Object {
    public var type: ObjectType { "String" }
    public var value: String

    public var description: String {
        "\(value.description)"
    }

    /// Concatenate two `MString` values
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: A new `MString` containing the concatenation of `lhs` and `rhs`
    public static func + (lhs: MString, rhs: MString) -> MString {
        return MString(value: lhs.value + rhs.value)
    }

    /// Concatenate two `MString` values
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: A new `MString` containing the concatenation of `lhs` and `rhs`
    public static func + (lhs: MString, rhs: Object?) -> MString {
        return MString(value: lhs.value + (rhs?.description ?? "null"))
    }

    /// Concatenate two `MString` values
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: A new `MString` containing the concatenation of `lhs` and `rhs`
    public static func + (lhs: Object?, rhs: MString) -> MString {
        return MString(value: (lhs?.description ?? "null") + rhs.value)
    }

    /// Compares two `MString` values
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: `true` if `lhs` is equal to `rhs` otherwise `false`
    public static func == (lhs: MString, rhs: MString) -> Boolean {
        return Boolean(lhs.value == rhs.value)
    }

    /// Compares two `MString` values
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`
    public static func != (lhs: MString, rhs: MString) -> Boolean {
        return Boolean(lhs.value != rhs.value)
    }

    /// Compares an `MString` with other `Object` value
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `Object` value
    /// - Returns: `true` if `rhs` is an MString and it is equal to `lhs` otherwise `false`
    public static func == (lhs: MString, rhs: Object?) -> Boolean {
        guard let string = rhs as? MString else {
            return .false
        }
        return lhs == string
    }

    /// Compares an `MString` with other `Object` value
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: `false` if `rhs` is an MString and it is equal to `lhs` otherwise `false`
    public static func != (lhs: MString, rhs: Object?) -> Boolean {
        guard let string = rhs as? MString else {
            return .true
        }
        return lhs != string
    }

    /// Compares an `MString` with other `Object` value
    /// - Parameters:
    ///   - lhs: An `Object` value
    ///   - rhs: An `MString` value
    /// - Returns: `true` if `lhs` is an MString and it is equal to `rhs` otherwise `false`
    public static func == (lhs: Object, rhs: MString) -> Boolean {
        guard let string = lhs as? MString else {
            return .false
        }
        return lhs == string
    }

    /// Compares an `MString` with other `Object` value
    /// - Parameters:
    ///   - lhs: An `MString` value
    ///   - rhs: An `MString` value
    /// - Returns: `false` if `lhs` is an MString and it is equal to `rhs` otherwise `false`
    public static func != (lhs: Object?, rhs: MString) -> Boolean {
        guard let string = lhs as? MString else {
            return .true
        }
        return lhs != string
    }
}
