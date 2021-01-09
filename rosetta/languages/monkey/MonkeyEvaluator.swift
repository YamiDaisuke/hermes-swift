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
        case let infix as InfixExpression:
            let lhs = eval(node: infix.lhs)
            let rhs = eval(node: infix.rhs)
            return evalInfix(lhs: lhs, operatorSymbol: infix.operatorSymbol, rhs: rhs)
        case let statement as IntegerLiteral:
            return Integer(value: statement.value)
        case let statement as BooleanLiteral:
            return statement.value ? Boolean.true : Boolean.false
        default:
            return nil
        }
    }

    // MARK: - Prefix Operators

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

    // MARK: Infix Operators

    static func evalInfix(lhs: Object?, operatorSymbol: String, rhs: Object?) -> Object? {
        switch operatorSymbol {
        case "+":
            return applyIntegerInfix(lhs: lhs, rhs: rhs, operation: +)
        case "-":
            return applyIntegerInfix(lhs: lhs, rhs: rhs, operation: -)
        case "*":
            return applyIntegerInfix(lhs: lhs, rhs: rhs, operation: *)
        case "/":
            return applyIntegerInfix(lhs: lhs, rhs: rhs, operation: /)
        case ">":
            return applyIntegerInfix(lhs: lhs, rhs: rhs, operation: >)
        case "<":
            return applyIntegerInfix(lhs: lhs, rhs: rhs, operation: <)
        case "==":
            return applyEqualInfix(lhs: lhs, rhs: rhs)
        case "!=":
            return applyInequalityInfix(lhs: lhs, rhs: rhs)
        default:
            return Null.null
        }
    }

    static func applyIntegerInfix(lhs: Object?, rhs: Object?, operation: (Integer,Integer) -> Object) -> Object? {
        guard let lhs = lhs as? Integer else {
            // TODO: Throw an error
            return Null.null
        }

        guard let rhs = rhs as? Integer else {
            // TODO: Throw an error
            return Null.null
        }

        return operation(lhs, rhs)
    }

    static func applyEqualInfix(lhs: Object?, rhs: Object?) -> Boolean? {
        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs == rhs
        }

        if let rhs = rhs as? Boolean {
            return lhs == rhs
        }

        if let lhs = lhs as? Boolean {
            return lhs == rhs
        }

        return .false
    }

    static func applyInequalityInfix(lhs: Object?, rhs: Object?) -> Boolean? {
        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs != rhs
        }

        if let rhs = rhs as? Boolean {
            return lhs != rhs
        }

        if let lhs = lhs as? Boolean {
            return lhs != rhs
        }

        return .false
    }
}
