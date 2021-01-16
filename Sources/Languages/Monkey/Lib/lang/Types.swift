//
//  Object.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation
import Rosetta

public typealias ObjectType = String

/// Base Type for all variables inside Monkey Language
/// think of this like the `Any` type of swift or `object`
/// type in C#
public protocol Object: CustomStringConvertible {
    var type: ObjectType { get }
}

/// Represents an empty value
public struct Null: Object {
    /// Convinience constant, there is no need to have a null instance
    /// for each expression that results with null
    public static let null = Null()
    public var type: ObjectType { "null" }

    public var description: String { "null" }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `true` if `lhs` is `Null`, `false` otherwise
    public static func equals(lhs: Object?, rhs: Null) -> Boolean {
        lhs is Null ? .true : .false
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `false` if `lhs` is `Null`, `true` otherwise
    public static func notEquals(lhs: Object?, rhs: Null) -> Boolean {
        !equals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `true` if `lhs` is `Null`, `false` otherwise
    public static func == (lhs: Object?, rhs: Null) -> Boolean {
        equals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Null` agaist an `Object` value
    ///
    /// - Parameters:
    ///   - lhs: The `Null` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `true` if `rhs` is `Null`, `false` otherwise
    public static func == (lhs: Null, rhs: Object?) -> Boolean {
        equals(lhs: rhs, rhs: lhs)
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `false` if `lhs` is `Null`, `true` otherwise
    public static func != (lhs: Object?, rhs: Null) -> Boolean {
        notEquals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: The `Null` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `false` if `rhs` is `Null`, `true` otherwise
    public static func != (lhs: Null, rhs: Object?) -> Boolean {
        notEquals(lhs: rhs, rhs: lhs)
    }
}

/// Wrapper tto represent `return`, control transfer statement
public struct Return: Object {
    public var type: ObjectType { "return" }
    /// The returned value
    public var value: Object?

    public var description: String {
        "return \(value?.description ?? "null")"
    }
}

public struct Integer: Object {
    public var type: ObjectType { "Integer" }
    public var value: Int

    public var description: String {
        value.description
    }

    /// Returns the result of multiply the value of this `Integer` by -1
    /// - Parameter rhs: The `Integer`value
    /// - Returns: Negative `rhs` if it is Positive and Positve `rhs` otherwise
    public static prefix func - (rhs: Integer) -> Integer {
        return Integer(value: -rhs.value)
    }

    /// Adds two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `Integer` containing the sum of `lhs` and `rhs`
    public static func + (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(value: lhs.value + rhs.value)
    }

    /// Substract two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `Integer` containing the substraction of `rhs` from `lhs`
    public static func - (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(value: lhs.value - rhs.value)
    }

    /// Multiply two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `Integer` containing the product of `lhs` times `rhs`
    public static func * (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(value: lhs.value * rhs.value)
    }

    /// Adds two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `Integer` containing the division of `lhs` divided by `rhs`
    public static func / (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(value: lhs.value / rhs.value)
    }

    /// Compares two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is greater than `rhs` otherwise `false`
    public static func > (lhs: Integer, rhs: Integer) -> Boolean {
        return Boolean(lhs.value > rhs.value)
    }

    /// Compares two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is lower than `rhs` otherwise `false`
    public static func < (lhs: Integer, rhs: Integer) -> Boolean {
        return Boolean(lhs.value < rhs.value)
    }

    /// Compares two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is equal to `rhs` otherwise `false`
    public static func == (lhs: Integer, rhs: Integer) -> Boolean {
        return Boolean(lhs.value == rhs.value)
    }

    /// Compares two `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`
    public static func != (lhs: Integer, rhs: Integer) -> Boolean {
        return Boolean(lhs.value != rhs.value)
    }
}

public struct Boolean: Object {
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

    public var description: String {
        value.description
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

/// Represents any function from the MonkeyLanguage
/// `Function` instances can be called and executed
/// at any point by having an identifier pointing to it.
/// Or by explicity calling it at the moment of declaration
public struct Function: Object {
    public var type: ObjectType { "function" }
    public var parameters: [String]
    var body: BlockStatement
    /// This will be a reference to the function outer environment
    public var environment: Environment<Object>

    public var description: String {
        "fn(\(parameters.joined(separator: ", "))) \(body)"
    }
}

/// Monkey Language `String` object, we have
/// to callit `MString` to avoid colissions with swift
/// `String`
public struct MString: Object {
    public var type: ObjectType { "String" }
    public var value: String

    public var description: String {
        "\(value.description)"
    }
}
