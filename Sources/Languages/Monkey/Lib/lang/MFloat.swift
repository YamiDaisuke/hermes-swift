//
//  MFloat.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 03-04-21.
//

import Foundation

/// An Float value in Monkey
public struct MFloat: Object, Hashable {
    public static var type: ObjectType { "Float" }
    public var value: Float64

    public init(_ value: Float64) {
        self.value = value
    }

    public var description: String {
        value.description
    }

    public func isEquals(other: Object) -> Bool {
        guard let other = other as? MFloat else { return false }
        return Bool(other == self)
    }

    /// Returns the result of multiply the value of this `MFloat` by -1
    /// - Parameter rhs: The `MFloat`value
    /// - Returns: Negative `rhs` if it is Positive and Positve `rhs` otherwise
    public static prefix func - (rhs: MFloat) -> MFloat {
        return MFloat(-rhs.value)
    }
}

// MARK: - Addition

extension MFloat {
    /// Adds two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the sum of `lhs` and `rhs`
    public static func + (lhs: MFloat, rhs: MFloat) -> MFloat {
        return MFloat(lhs.value + rhs.value)
    }

    /// Adds a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `MFloat` containing the sum of `lhs` and `rhs`
    public static func + (lhs: MFloat, rhs: Integer) -> MFloat {
        return MFloat(lhs.value + Float64(rhs.value))
    }

    /// Adds a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `MFloat` containing the sum of `lhs` and `rhs`
    public static func + (lhs: Integer, rhs: MFloat) -> MFloat {
        return MFloat(Float64(lhs.value) + rhs.value)
    }
}

// MARK: - Substraction

extension MFloat {
    /// Substract two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the substraction of `lhs` from `rhs`
    public static func - (lhs: MFloat, rhs: MFloat) -> MFloat {
        return MFloat(lhs.value - rhs.value)
    }

    /// Substract a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `MFloat` containing the substraction of `lhs` from `rhs`
    public static func - (lhs: MFloat, rhs: Integer) -> MFloat {
        return MFloat(lhs.value - Float64(rhs.value))
    }

    /// Substract a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the substraction of `lhs` from `rhs`
    public static func - (lhs: Integer, rhs: MFloat) -> MFloat {
        return MFloat(Float64(lhs.value) - rhs.value)
    }
}

// MARK: - Multiplication

extension MFloat {
    /// Multiply two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the product of `lhs` times `rhs`
    public static func * (lhs: MFloat, rhs: MFloat) -> MFloat {
        return MFloat(lhs.value * rhs.value)
    }

    /// Multiply a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `MFloat` containing the product of `lhs` times `rhs`
    public static func * (lhs: MFloat, rhs: Integer) -> MFloat {
        return MFloat(lhs.value * Float64(rhs.value))
    }

    /// Multiply a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the product of `lhs` times `rhs`
    public static func * (lhs: Integer, rhs: MFloat) -> MFloat {
        return MFloat(Float64(lhs.value) * rhs.value)
    }
}

// MARK: - Division

extension MFloat {
    /// Adds two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the division of `lhs` divided by `rhs`
    public static func / (lhs: MFloat, rhs: MFloat) -> MFloat {
        return MFloat(lhs.value / rhs.value)
    }

    /// Adds a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: A new `MFloat` containing the division of `lhs` divided by `rhs`
    public static func / (lhs: MFloat, rhs: Integer) -> MFloat {
        return MFloat(lhs.value / Float64(rhs.value))
    }

    /// Adds a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: A new `MFloat` containing the division of `lhs` divided by `rhs`
    public static func / (lhs: Integer, rhs: MFloat) -> MFloat {
        return MFloat(Float64(lhs.value) / rhs.value)
    }
}

// MARK: - Comparision

extension MFloat {
    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is greater than `rhs` otherwise `false`
    public static func > (lhs: MFloat, rhs: MFloat) -> Boolean {
        return Boolean(lhs.value > rhs.value)
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is greater than `rhs` otherwise `false`
    public static func > (lhs: MFloat, rhs: Integer) -> Boolean {
        return Boolean(lhs.value > Float64(rhs.value))
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is greater than `rhs` otherwise `false`
    public static func > (lhs: Integer, rhs: MFloat) -> Boolean {
        return Boolean(Float64(lhs.value) > rhs.value)
    }

    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is greater than or equals to `rhs` otherwise `false`
    public static func >= (lhs: MFloat, rhs: MFloat) -> Boolean {
        return Boolean(lhs.value >= rhs.value)
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is greater than or equals to `rhs` otherwise `false`
    public static func >= (lhs: MFloat, rhs: Integer) -> Boolean {
        return Boolean(lhs.value >= Float64(rhs.value))
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is greater than or equals `rhs` otherwise `false`
    public static func >= (lhs: Integer, rhs: MFloat) -> Boolean {
        return Boolean(Float64(lhs.value) >= rhs.value)
    }

    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is lower than `rhs` otherwise `false`
    public static func < (lhs: MFloat, rhs: MFloat) -> Boolean {
        return Boolean(lhs.value < rhs.value)
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is lower than `rhs` otherwise `false`
    public static func < (lhs: MFloat, rhs: Integer) -> Boolean {
        return Boolean(lhs.value < Float64(rhs.value))
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is lower than `rhs` otherwise `false`
    public static func < (lhs: Integer, rhs: MFloat) -> Boolean {
        return Boolean(Float64(lhs.value) < rhs.value)
    }


    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is lower than or equals to `rhs` otherwise `false`
    public static func <= (lhs: MFloat, rhs: MFloat) -> Boolean {
        return Boolean(lhs.value <= rhs.value)
    }

    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is lower than or equals to `rhs` otherwise `false`
    public static func <= (lhs: MFloat, rhs: Integer) -> Boolean {
        return Boolean(lhs.value <= Float64(rhs.value))
    }

    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is lower than or equals to `rhs` otherwise `false`
    public static func <= (lhs: Integer, rhs: MFloat) -> Boolean {
        return Boolean(Float64(lhs.value) <= rhs.value)
    }
}

// MARK: - Equality

extension MFloat {
    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is equal to `rhs` otherwise `false`
    public static func == (lhs: MFloat, rhs: MFloat) -> Boolean {
        return Boolean(lhs.value == rhs.value)
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is equal to `rhs` otherwise `false`
    public static func == (lhs: MFloat, rhs: Integer) -> Boolean {
        return Boolean(lhs.value == Float64(rhs.value))
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is equal to `rhs` otherwise `false`
    public static func == (lhs: Integer, rhs: MFloat) -> Boolean {
        return Boolean(Float64(lhs.value) == rhs.value)
    }

    /// Compares two `MFloat` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`
    public static func != (lhs: MFloat, rhs: MFloat) -> Boolean {
        return Boolean(lhs.value != rhs.value)
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `MFloat` value
    ///   - rhs: An `Integer` value
    /// - Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`
    public static func != (lhs: MFloat, rhs: Integer) -> Boolean {
        return Boolean(lhs.value != Float64(rhs.value))
    }

    /// Compares a `MFloat` and an `Integer` values
    /// - Parameters:
    ///   - lhs: An `Integer` value
    ///   - rhs: An `MFloat` value
    /// - Returns: `true` if `lhs` is not equal to `rhs` otherwise `false`
    public static func != (lhs: Integer, rhs: MFloat) -> Boolean {
        return Boolean(Float64(lhs.value) != rhs.value)
    }
}
