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

    static func eval(program: Program) -> BaseType?
    static func eval(node: Node) -> BaseType?
}

extension Evaluator {
    static func eval(program: Program) -> BaseType? {
        var result: BaseType?
        for statement in program.statements {
            result = Self.eval(node: statement)
        }

        return result
    }
}
