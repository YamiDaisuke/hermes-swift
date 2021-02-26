//
//  VMOperations.swift
//  Rosetta
//
//  Created by Franklin Cruz on 04-02-21.
//

import Foundation

public protocol VMOperations {
    associatedtype BaseType

    /// Gets the empty value representation for the implementing language
    var null: BaseType { get }

    /// Maps and applies binary operation on the implementing language
    /// - Parameters:
    ///   - lhs: The left hand operand
    ///   - rhs: The right hand operand
    /// - Throws: A language specific error if the values or the operator is not recognized
    /// - Returns: The result of the operation depending on the operands
    func binaryOperation<BaseType>(lhs: BaseType, rhs: BaseType, operation: OpCodes) throws -> BaseType

    /// Maps and applies unary operation on the implementing language
    /// - Parameters:
    ///   - rhs: The right hand operand
    /// - Throws: A language specific error if the values or the operator is not recognized
    /// - Returns: The result of the operation depending on the operand
    func unaryOperation<BaseType>(rhs: BaseType, operation: OpCodes) throws -> BaseType

    /// Gets the language specific representation of a VM boolean value
    ///
    /// We could simple use native `Bool` from swift but in this way we keep all
    /// the values independent of the swift language.
    /// - Parameter bool: The swift `Bool` value to wrap
    /// - Returns: A representation of swift `Bool` in the implementing language
    func getLangBool(for bool: Bool) -> BaseType


    /// Check if a value of the implemeting language is considered an equivalent of `true`
    /// - Parameter value: The value to check
    /// - Returns: `true` if the given value is considered truthy in the implementing language
    func isTruthy(_ value: BaseType?) -> Bool

    /// Takes a native Swift array of the lang base type and converts it to the lang equivalent
    /// - Parameter array: An swift Array 
    func buildLangArray(from array: [BaseType]) -> BaseType

    /// Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
    /// - Parameter array: An swift dictionary
    func buildLangHash(from array: [AnyHashable: BaseType]) -> BaseType

    /// Performs an language index (A.K.A subscript) operation in the form of: `<expression>[<expression>]`
    /// - Parameters:
    ///   - lhs: The value to be indexed
    ///   - index: The index to apply
    func executeIndexExpression(_ lhs: BaseType, index: BaseType) throws -> BaseType
}
