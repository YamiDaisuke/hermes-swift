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
    /// Gets the empty value representation for the implementing language
    public var null: VMBaseType {
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
    public func binaryOperation(lhs: VMBaseType?, rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType {
        guard let lhs = lhs as? Object else { return self.null }
        guard let rhs = rhs as? Object else { return self.null }
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

        return try MonkeyOperations.evalInfix(lhs: lhs, operatorSymbol: symbol, rhs: rhs)
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
    public func unaryOperation(rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType {
        guard let rhs = rhs as? Object else { return self.null }
        var symbol = ""
        switch operation {
        case .minus:
            symbol = "-"
        case .bang:
            symbol = "!"
        default:
            throw UnknownOperator(String(format: "%02X", operation.rawValue))
        }

        return try MonkeyOperations.evalPrefix(operator: symbol, rhs: rhs) ?? self.null
    }


    /// Gets the language specific representation of a VM boolean value
    ///
    /// We could simple use native `Bool` from swift but in this way we keep all
    /// the values independent of the swift language.
    /// - Parameter bool: The swift `Bool` value to wrap
    /// - Returns: A representation of swift `Bool` in Monkey language which will be `Boolean`
    public func getLangBool(for bool: Bool) -> VMBaseType {
        Boolean(bool)
    }


    /// Check if an `Object` is considered truthy
    /// - Parameter value: The value to check
    /// - Returns: `true` if the given value is considered truthy
    public func isTruthy(_ value: VMBaseType?) -> Bool {
        let casted = value as? Object
        return ((casted ?? Boolean.false) == Boolean.true).value
    }

    /// Takes a native Swift array of the lang base type and converts it to the lang equivalent
    /// - Parameter array: An swift Array 
    public func buildLangArray(from array: [VMBaseType]) -> VMBaseType {
        return MArray(elements: array as! [Object])
    }

    /// Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
    /// - Parameter array: An swift dictionary
    public func buildLangHash(from dictionary: [AnyHashable: VMBaseType]) -> VMBaseType {
        return Hash(pairs: dictionary as! [AnyHashable: Object])
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
    public func executeIndexExpression(_ lhs: VMBaseType, index: VMBaseType) throws -> VMBaseType {
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
    public func decodeFunction(_ function: VMBaseType) -> VMFunctionDefinition? {
        guard let function = function as? CompiledFunction else {
            return nil
        }

        return function
    }

    /// Gets a language specific builtin function
    /// - Parameter index: The function index generated by the compiler
    /// - Returns: An object representing the requested function
    public func getBuiltinFunction(_ index: Int) -> VMBaseType? {
        return BuiltinFunction[index]
    }

    /// Should execute a builtin function and
    /// - Parameter function: The function to execute
    /// - Returns: The produced value or nil if `function` is not a valid BuiltIn function
    public func executeBuiltinFunction(_ function: VMBaseType, args: [VMBaseType]) throws -> VMBaseType? {
        guard let bultin = function as? BuiltinFunction else {
            return nil
        }

        return try bultin.function(args as! [Object]) ?? Null.null
    }

    func executeArrayIndexExpression(_ lhs: MArray, index: VMBaseType) throws -> VMBaseType {
        guard let integer = index as? Integer else {
            throw InvalidArrayIndex(index)
        }

        return lhs[integer]
    }

    func executeHashIndexExpression(_ lhs: Hash, index: VMBaseType) throws -> VMBaseType {
        return try lhs.get(index as! Object) ?? Null.null
    }
}
