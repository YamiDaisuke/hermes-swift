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
        case let prefix as PrefixExpression:
            let rhs = eval(node: prefix.rhs)
            return evalPrefix(operator: prefix.operatorSymbol, rhs: rhs)
        case let statement as IntegerLiteral:
            return Integer(value: statement.value)
        case let statement as BooleanLiteral:
            return statement.value ? Boolean.true : Boolean.false
        default:
            return nil
        }
    }

    /// Applies a prefix operator agaist any `Object` value.
    ///
    /// Currenty supported operators are:
    /// - `!<rhs>` where `rhs` can be of type `Boolean` or  `Integer`
    /// - `-<rhs>` where `rhs` can be of type `Integer`
    /// - Parameters:
    ///   - operatorSymbol: A `String` representing the operator. E.G.: !, -
    ///   - rhs: The `Object` to apply  the operator
    /// - Returns: The resulting value after applying the operator or `Null` if the operator
    ///            does not support the type of `rhs`
    static func evalPrefix(operator operatorSymbol: String, rhs: Object?) -> Object? {
        switch operatorSymbol {
        case "!":
            return evalBangOperator(rhs: rhs)
        case "-":
            return evalMinusPrefix(rhs: rhs)
        default:
            // TODO: Throw an error
            return Null.null
        }
    }

    /// Evals minus (-) prefix operator
    /// - Parameter rhs: An `Object` value
    /// - Returns: The resul of multiplying a `Integer` value by -1.
    ///            If the `Object` can't be cast to `Integer` returns `Null`
    static func evalMinusPrefix(rhs: Object?) -> Object? {
        guard let int = rhs as? Integer else {
            // TODO: Throw an error
            return Null.null
        }

        return -int
    }

    /// Evals bang (!) prefix operator
    /// - Parameter rhs: An `Object` value
    /// - Returns: The negation of the `Boolean` representation of `rhs`.
    ///            If `rhs` is an `Integer` any value other than `0` will produce `true`
    ///            when represented as `Boolean`.
    ///            If `rhs` is `Null` the `Boolean` representation is `false`
    static func evalBangOperator(rhs: Object?) -> Object? {
        return rhs != Boolean.true
    }
}
