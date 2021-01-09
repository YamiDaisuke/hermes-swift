//
//  Object.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation

typealias ObjectType = String

protocol Object: CustomStringConvertible {
    var type: ObjectType { get }
}

struct Null: Object {
    /// Convinience constant, there is no need to have a null instance
    /// for each expression that results with null
    static let null = Null()
    var type: ObjectType { "null" }

    var description: String { "null" }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `true` if `lhs` is `Null`, `false` otherwise
    static func equals(lhs: Object?, rhs: Null) -> Boolean {
        lhs is Null ? .true : .false
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `false` if `lhs` is `Null`, `true` otherwise
    static func notEquals(lhs: Object?, rhs: Null) -> Boolean {
        !equals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `true` if `lhs` is `Null`, `false` otherwise
    static func == (lhs: Object?, rhs: Null) -> Boolean {
        equals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Null` agaist an `Object` value
    ///
    /// - Parameters:
    ///   - lhs: The `Null` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `true` if `rhs` is `Null`, `false` otherwise
    static func == (lhs: Null, rhs: Object?) -> Boolean {
        equals(lhs: rhs, rhs: lhs)
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: The `Null` value
    /// - Returns: `false` if `lhs` is `Null`, `true` otherwise
    static func != (lhs: Object?, rhs: Null) -> Boolean {
        notEquals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist the `Null` value
    ///
    /// - Parameters:
    ///   - lhs: The `Null` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `false` if `rhs` is `Null`, `true` otherwise
    static func != (lhs: Null, rhs: Object?) -> Boolean {
        notEquals(lhs: rhs, rhs: lhs)
    }
}

struct Integer: Object {
    var type: ObjectType { "Integer" }
    var value: Int

    var description: String {
        value.description
    }

    /// Returns the result of multiply the value of this `Integer` by -1
    /// - Parameter rhs: The `Integer`value
    /// - Returns: Negative `rhs` if it is Positive and Positve `rhs` otherwise
    static prefix func - (rhs: Integer) -> Integer {
        return Integer(value: -rhs.value)
    }
}

struct Boolean: Object {
    /// Convinience constant, there is no need to have a Boole instance
    /// for each expression that results in either `true` or `false`
    static let `true` = Boolean(value: true)
    static let `false` = Boolean(value: false)

    var type: ObjectType { "Boolean" }
    var value: Bool

    var description: String {
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
            return int.value != 0 ? .true : .false
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
        !Boolean.equals(lhs: lhs, rhs: rhs)
    }

    /// Negates the value of a `Boolean` value
    /// - Parameter rhs: A `Boolean` value to negate
    /// - Returns: `false` if `rhs` is `true` and `true` otherwise
    static prefix func ! (rhs: Boolean) -> Boolean {
        rhs.value ? .false : .true
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: A `Boolean` value
    /// - Returns: `true` if `rhs` produces the same `Boolean` value as `rhs` otherwise `false`
    static func == (lhs: Object?, rhs: Boolean) -> Boolean {
        Boolean.equals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: A `Boolean` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `true` if `lhs` produces the same `Boolean` value as `rhs` otherwise `false`
    static func == (lhs: Boolean, rhs: Object?) -> Boolean {
        Boolean.equals(lhs: rhs, rhs: lhs)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: Any instance of `Object`
    ///   - rhs: A `Boolean` value
    /// - Returns: `false` if `lhs` produces the same `Boolean` value as `rhs` otherwise `true`
    static func != (lhs: Object?, rhs: Boolean) -> Boolean {
        Boolean.notEquals(lhs: lhs, rhs: rhs)
    }

    /// Compares any `Object` agaist a `Boolean` value
    ///
    /// - Parameters:
    ///   - lhs: A `Boolean` value
    ///   - rhs: Any instance of `Object`
    /// - Returns: `false` if `rhs` produces the same `Boolean` value as `lhs` otherwise `true`
    static func != (lhs: Boolean, rhs: Object?) -> Boolean {
        Boolean.notEquals(lhs: rhs, rhs: lhs)
    }
}
