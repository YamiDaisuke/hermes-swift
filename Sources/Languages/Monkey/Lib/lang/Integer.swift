//
//  Integer.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation

/// An Integer value in Monkey
public struct Integer: Object, Hashable {
    public var type: ObjectType { "Integer" }
    public var value: Int

    public var description: String {
        value.description
    }

    public func isEquals(other: Object) -> Bool {
        guard let other = other as? Integer else { return false }
        return Bool(other == self)
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
    /// - Returns: `true` if `lhs` is greater than or equals to `rhs` otherwise `false`
    public static func >= (lhs: Integer, rhs: Integer) -> Boolean {
        return Boolean(lhs.value >= rhs.value)
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
    /// - Returns: `true` if `lhs` is lower than or equals to `rhs` otherwise `false`
    public static func <= (lhs: Integer, rhs: Integer) -> Boolean {
        return Boolean(lhs.value <= rhs.value)
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
