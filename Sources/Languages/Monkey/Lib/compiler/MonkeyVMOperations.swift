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
        default:
            throw UnknownOperator(String(format: "%02X", operation.rawValue))
        }

        return try MonkeyOperations.evalInfix(lhs: lhs, operatorSymbol: symbol, rhs: rhs) as! BaseType
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
}
