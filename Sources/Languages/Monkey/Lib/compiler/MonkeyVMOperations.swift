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

    /// Apply addition operation to two supported objects
    ///
    /// Supported variations are:
    /// ```
    /// Integer + Integer
    /// String + Object // Using the Object String representation
    /// ```
    /// - Parameters:
    ///   - lhs: The left hand operand
    ///   - rhs: The right hand operand
    /// - Throws: `InvalidInfixExpression` if any of the operands is not supported
    /// - Returns: The result of the operation depending on the operands
    public func add<BaseType>(lhs: BaseType, rhs: BaseType) throws -> BaseType {
        let lhs = lhs as! Object
        let rhs = rhs as! Object
        let result = try MonkeyOperations.applyAddition(lhs: lhs, rhs: rhs)
        return result as! BaseType
    }
}
