//
//  MonkeyVMOperations.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 04-02-21.
//

import Foundation
import Rosetta

// swiftlint:disable force_cast
public struct MonkeyVMOperations: VMOperations {
    public typealias BaseType = Object

    /// Gets the empty value representation for the implementing language
    public var null: BaseType {
        Null.null
    }

    public init() { }

    /// Maps and applies binary operation to the right Monkey operation
    ///
    /// Supported variations are:
    /// ```
    /// Integer + Integer
    /// String + Object // Using the Object String representation
    /// Integer - Integer
    /// Integer * Integer
    /// Integer / Integer
    /// ```
    /// - Parameters:
    ///   - lhs: The left hand operand
    ///   - rhs: The right hand operand
    /// - Throws: `InvalidInfixExpression` if any of the operands is not supported.
    ///           `UnknownOperator` if the bytecode operator doesn't match a monkey operation
    /// - Returns: The result of the operation depending on the operands
    public func binaryOperation<BaseType>(lhs: BaseType, rhs: BaseType, operation: OpCodes) throws -> BaseType {
        let lhs = lhs as! Object
        let rhs = rhs as! Object
        var symbol = ""
        switch operation {
        case .add:
            symbol = "+"
        case .sub:
            symbol = "-"
        case .mul:
            symbol = "*"
        case .div:
            symbol = "/"
        case .equal:
            symbol = "=="
        case .notEqual:
            symbol = "!="
        case .gt:
            symbol = ">"
        case .gte:
            symbol = ">="
        default:
            throw UnknownOperator(String(format: "%02X", operation.rawValue))
        }

        return try MonkeyOperations.evalInfix(lhs: lhs, operatorSymbol: symbol, rhs: rhs) as! BaseType
    }

    /// Maps and applies unary operation to the right Monkey operation
    ///
    /// Supported variations are:
    /// ```
    /// !Object
    /// -Integer
    /// ```
    /// - Parameters:
    ///   - rhs: The right hand operand
    /// - Throws: `InvalidPrefixExpression` if any of the operands is not supported.
    ///           `UnknownOperator` if the bytecode operator doesn't match a monkey operation
    /// - Returns: The result of the operation depending on the operands
    public func unaryOperation<BaseType>(rhs: BaseType, operation: OpCodes) throws -> BaseType {
        let rhs = rhs as! Object
        var symbol = ""
        switch operation {
        case .minus:
            symbol = "-"
        case .bang:
            symbol = "!"
        default:
            throw UnknownOperator(String(format: "%02X", operation.rawValue))
        }

        return try MonkeyOperations.evalPrefix(operator: symbol, rhs: rhs) as! BaseType
    }


    /// Gets the language specific representation of a VM boolean value
    ///
    /// We could simple use native `Bool` from swift but in this way we keep all
    /// the values independent of the swift language.
    /// - Parameter bool: The swift `Bool` value to wrap
    /// - Returns: A representation of swift `Bool` in Monkey language which will be `Boolean`
    public func getLangBool(for bool: Bool) -> BaseType {
        Boolean(bool)
    }


    /// Check if an `Object` is considered truthy
    /// - Parameter value: The value to check
    /// - Returns: `true` if the given value is considered truthy
    public func isTruthy(_ value: BaseType?) -> Bool {
        return ((value ?? Boolean.false) == Boolean.true).value
    }

    /// Takes a native Swift array of the lang base type and converts it to the lang equivalent
    /// - Parameter array: An swift Array 
    public func buildLangArray(from array: [Object]) -> Object {
        return MArray(elements: array)
    }

    /// Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
    /// - Parameter array: An swift dictionary
    public func buildLangHash(from dictionary: [AnyHashable: Object]) -> Object {
        return Hash(pairs: dictionary)
    }

    /// Performs an language index (A.K.A subscript) operation in the form of: `<expression>[<expression>]`
    ///
    /// Supported options are:
    /// ```
    /// <Array>[<Integer>]
    /// <Hash>[<Integer|String>]
    /// ```
    /// - Parameters:
    ///   - lhs: An `MArray`  or `Hash`
    ///   - index: The value to use as index
    /// - Throws: `IndexNotSupported` if `lhs` is not the right type.
    ///           `InvalidArrayIndex` or `InvalidHashKey` if  `index` can't be applied to `lhs`
    /// - Returns: The value associated wiith the `index` or `null`
    public func executeIndexExpression(_ lhs: BaseType, index: BaseType) throws -> BaseType {
        switch lhs {
        case let array as MArray:
            return try executeArrayIndexExpression(array, index: index)
        case let hash as Hash:
            return try executeHashIndexExpression(hash, index: index)
        default:
            throw IndexNotSupported(lhs)
        }
    }

    /// Extract the VM instructions and locals count from a language especific compiled function
    /// - Parameter function: The supposed function
    /// - Returns: A tuple with the instructions and the locals count or `nil`
    ///            if `function` is not actually a compiled function representation
    public func decodeFunction(_ function: BaseType) -> (instructions: Instructions, locals: Int)? {
        guard let function = function as? CompiledFunction else {
            return nil
        }

        return (function.instructions, function.localsCount)
    }

    func executeArrayIndexExpression(_ lhs: MArray, index: BaseType) throws -> BaseType {
        guard let integer = index as? Integer else {
            throw InvalidArrayIndex(index)
        }

        return lhs[integer]
    }

    func executeHashIndexExpression(_ lhs: Hash, index: BaseType) throws -> BaseType {
        return try lhs.get(index) ?? Null.null
    }
}
