//
//  Boolean.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation

/// A Boolean value in Monkey
public struct Boolean: Object, Hashable {
    /// Convinience constant, there is no need to have a Boole instance
    /// for each expression that results in either `true` or `false`
    public static let `true` = Boolean(value: true)
    public static let `false` = Boolean(value: false)

    public var type: ObjectType { "Boolean" }
    public var value: Bool

    /// Private init so we only have two instances of `Boolean`
    /// at all times
    private init(value: Bool) {
        self.value = value
    }

    /// Convinience cast a swift `Bool` to one of the
    /// `Bolean` constants
    public init(_ bool: Bool) {
        self = bool ? .true : .false
    }

    /// Convinience cast an `Integer` to one of the
    /// `Bolean` constants. `0` matches to `false`
    /// any other `Integer` maps to `true`
    public init(_ integer: Integer) {
        self = integer.value != 0 ? .true : .false
    }

    /// Convinience cast an `MString` to one of the
    /// `Bolean` constants. `""` matches to `false`
    /// any other `MString` maps to `true`
    public init(_ string: MString) {
        self = !string.value.isEmpty ? .true : .false
    }

    public var description: String {
        value.description
    }

    public func isEquals(other: Object) -> Bool {
        guard let other = other as? Boolean else {
            return false
        }

        return Bool(self == other)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: A `Boolean` value
    /// - Returns: `true` if `rhs` produces the same `Boolean` value as `rhs` otherwise `false`
    private static func equals(lhs: Object?, rhs: Boolean) -> Boolean {
        switch lhs {
        case let bool as Boolean:
            return bool.value == rhs.value ? .true : .false
        case let int as Integer:
            return Boolean(int).value == rhs.value ? .true : .false
        case let string as MString:
            return Boolean(string).value == rhs.value ? .true : .false
        case _ as Null:
            return rhs.value == false ? .true : .false
        default:
            return .false
        }
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: A `Boolean` value
    /// - Returns: `false` if `lhs` produces the same `Boolean` value as `rhs` otherwise `true`
    private static func notEquals(lhs: Object?, rhs: Boolean) -> Boolean {
        return !Boolean.equals(lhs: lhs, rhs: rhs)
    }

    /// Negates the value of a `Boolean` value
    /// - Parameter rhs: A `Boolean` value to negate
    /// - Returns: `false` if `rhs` is `true` and `true` otherwise
    public static prefix func ! (rhs: Boolean) -> Boolean {
        return rhs.value ? .false : .true
    }

    /// Compares two `Boolean` values
    ///
    /// - Parameters:
    ///   - lhs: A `Boolean` value
    ///   - rhs: A `Boolean` value
    /// - Returns: `true` if `lhs` is equals to `rhs` otherwise `false`
    public static func == (lhs: Boolean, rhs: Boolean) -> Boolean {
        return Boolean(lhs.value == rhs.value)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: A `Boolean` value
    /// - Returns: `true` if `rhs` produces the same `Boolean` value as `rhs` otherwise `false`
    public static func == (lhs: Object?, rhs: Boolean) -> Boolean {
        return Boolean.equals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: A `Boolean` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `true` if `lhs` produces the same `Boolean` value as `rhs` otherwise `false`
    public static func == (lhs: Boolean, rhs: Object?) -> Boolean {
        return Boolean.equals(lhs: rhs, rhs: lhs)
    }

    /// Compares two `Boolean` values
    ///
    /// - Parameters:
    ///   - lhs: A `Boolean` value
    ///   - rhs: A `Boolean` value
    /// - Returns: `false` if `lhs` is equals to `rhs` otherwise `true`
    public static func != (lhs: Boolean, rhs: Boolean) -> Boolean {
        return Boolean(lhs.value != rhs.value)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: A `Boolean` value
    /// - Returns: `false` if `lhs` produces the same `Boolean` value as `rhs` otherwise `true`
    public static func != (lhs: Object?, rhs: Boolean) -> Boolean {
        return Boolean.notEquals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: A `Boolean` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `false` if `rhs` produces the same `Boolean` value as `lhs` otherwise `true`
    public static func != (lhs: Boolean, rhs: Object?) -> Boolean {
        return Boolean.notEquals(lhs: rhs, rhs: lhs)
    }
}

public extension Bool {
    init(_ boolean: Boolean) {
        self = boolean.value
    }
}
