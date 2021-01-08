//
//  MonkeyEvaluator.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation

struct MonkeyEvaluator: Evaluator {
    typealias BaseType = Object

    static func eval(node: Node) -> Object? {
        switch node {
        case let expression as ExpressionStatement:
            return eval(node: expression.expression)
        case let statement as IntegerLiteral:
            return Integer(value: statement.value)
        case let statement as BooleanLiteral:
            return statement.value ? Boolean.true : Boolean.false
        default:
            return nil
        }
    }
}
