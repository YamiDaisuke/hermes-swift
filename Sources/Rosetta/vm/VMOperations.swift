//
//  VMOperations.swift
//  Rosetta
//
//  Created by Franklin Cruz on 04-02-21.
//

import Foundation

public protocol VMOperations {
    associatedtype BaseType

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
}
