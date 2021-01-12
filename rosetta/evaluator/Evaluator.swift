//
//  Evaluator.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation

protocol Evaluator {
    /// This is the language base type for all types
    /// for example in swift this will be `Any` for
    /// c# will `object`
    associatedtype BaseType
    /// This is the language representation for results of
    /// statements that can change the app flow, This can
    /// be used for example for `return` and `break`
    /// statements
    associatedtype ControlTransfer

    static func eval(program: Program) -> BaseType?
    static func eval(node: Node) -> BaseType?


    /// Evaluates `ControlTransfer` wrapper and generates the corresponding output
    /// - Parameter statement: Some `ControlTransfer` statement wrapper like `return` or
    ///                        `break` statements
    static func handleControlTransfer(_ statement: ControlTransfer) -> BaseType?
}

extension Evaluator {
    static func eval(program: Program) -> BaseType? {
        var result: BaseType?
        for statement in program.statements {
            result = Self.eval(node: statement)

            if let result = result as? ControlTransfer {
                return handleControlTransfer(result)
            }
        }

        return result
    }
}
