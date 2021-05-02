//
//  VMOperations.swift
//  Hermes
//
//  Created by Franklin Cruz on 04-02-21.
//

import Foundation

public protocol VMOperations {
    /// A magic number used to check if a binary file was generated
    /// by a compiler compatible with this VMOperations. The number
    /// must match the one in the Compiler implementation for the target
    /// language
    var languageSignature: UInt32 { get }

    /// Gets the empty value representation for the implementing language
    var null: VMBaseType { get }

    /// Takes constants encoded as byte code and converts them to the right value
    /// - Parameter bytes: The encoded bytes
    /// - Throws: A language specific error if a value can't be decompiled
    /// - Returns: An array of values after decompilation
    func decompileConstants(fromBytes bytes: [Byte]) throws -> [VMBaseType]

    /// Maps and applies binary operation on the implementing language
    /// - Parameters:
    ///   - lhs: The left hand operand
    ///   - rhs: The right hand operand
    /// - Throws: A language specific error if the values or the operator is not recognized
    /// - Returns: The result of the operation depending on the operands
    func binaryOperation(lhs: VMBaseType?, rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType

    /// Maps and applies unary operation on the implementing language
    /// - Parameters:
    ///   - rhs: The right hand operand
    /// - Throws: A language specific error if the values or the operator is not recognized
    /// - Returns: The result of the operation depending on the operand
    func unaryOperation(rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType

    /// Gets the language specific representation of a VM boolean value
    ///
    /// We could simple use native `Bool` from swift but in this way we keep all
    /// the values independent of the swift language.
    /// - Parameter bool: The swift `Bool` value to wrap
    /// - Returns: A representation of swift `Bool` in the implementing language
    func getLangBool(for bool: Bool) -> VMBaseType


    /// Check if a value of the implemeting language is considered an equivalent of `true`
    /// - Parameter value: The value to check
    /// - Returns: `true` if the given value is considered truthy in the implementing language
    func isTruthy(_ value: VMBaseType?) -> Bool

    /// Takes a native Swift array of the lang base type and converts it to the lang equivalent
    /// - Parameter array: An swift Array
    func buildLangArray(from array: [VMBaseType]) -> VMBaseType

    /// Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
    /// - Parameter array: An swift dictionary
    func buildLangHash(from array: [AnyHashable: VMBaseType]) -> VMBaseType

    /// Performs an language index (A.K.A subscript) operation in the form of: `<expression>[<expression>]`
    /// - Parameters:
    ///   - lhs: The value to be indexed
    ///   - index: The index to apply
    func executeIndexExpression(_ lhs: VMBaseType, index: VMBaseType) throws -> VMBaseType


    /// Extract the VM instructions and locals count from a language especific compiled function
    /// - Parameter function: The supposed function
    /// - Returns: A value conforming the `VMFunctionDefinition` protocol or `nil`
    ///            if `function` is not actually a compiled function representation
    func decodeFunction(_ function: VMBaseType) -> VMFunctionDefinition?

    /// Gets a language specific builtin function
    /// - Parameter index: The function index generated by the compiler
    /// - Returns: An object representing the requested function
    func getBuiltinFunction(_ index: Int) -> VMBaseType?

    /// Should execute a builtin function
    /// - Parameter function: The function to execute
    /// - Returns: The produced value or nil if `function` is not a valid BuiltIn function
    func executeBuiltinFunction(_ function: VMBaseType, args: [VMBaseType]) throws -> VMBaseType?
}
