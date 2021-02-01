//
//  Null.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation

/// Represents an empty value
public struct Null: Object {
    /// Convinience constant, there is no need to have a null instance
    /// for each expression that results with null
    public static let null = Null()
    public var type: ObjectType { "null" }

    public var description: String { "null" }

    public func isEquals(other: Object) -> Bool {
        return Bool(self == other)
    }

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
