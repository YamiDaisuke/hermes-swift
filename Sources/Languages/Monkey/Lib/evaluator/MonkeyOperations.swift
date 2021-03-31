//
//  MonkeyOperations.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 04-02-21.
//

import Foundation

/// Abstract operation evaluation, this will help to reduce duplicated code
/// when applying the same operations inside the Rosetta VM
enum MonkeyOperations {
    // MARK: - Prefix Operators

    /// Applies a prefix operator agaist any `Object` value.
    ///
    /// Currenty supported operators are:
    /// - `!<rhs>` where `rhs` can be of type `Boolean` or  `Integer`
    /// - `-<rhs>` where `rhs` can be of type `Integer`
    /// - Parameters:
    ///   - operatorSymbol: A `String` representing the operator. E.G.: !, -
    ///   - rhs: The `Object` to apply  the operator
    /// - Throws: `UnknownOperator` if  `operatorSymbol` is not supported.
    ///           `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The resulting value after applying the operator or `Null` if the operator
    ///            does not support the type of `rhs`
    static func evalPrefix(operator operatorSymbol: String, rhs: Object?) throws -> Object? {
        switch operatorSymbol {
        case "!":
            return evalBangOperator(rhs: rhs)
        case "-":
            return try evalMinusPrefix(rhs: rhs)
        default:
            throw UnknownOperator(operatorSymbol)
        }
    }

    /// Evals minus (-) prefix operator
    /// - Parameter rhs: An `Object` value
    /// - Throws: `InvalidPrefixExpression` if the operand expression is not an `Integer`
    /// - Returns: The resul of multiplying a `Integer` value by -1.
    ///            If the `Object` can't be cast to `Integer` returns `Null`
    static func evalMinusPrefix(rhs: Object?) throws-> Object? {
        guard let int = rhs as? Integer else {
            throw InvalidPrefixExpression("-", rhs: rhs)
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

    // MARK: - Infix Operators

    /// Evals operations in the form `<expression> <operator> <expression>`
    ///
    /// Supported operators:
    /// - `<Integer> + <Integer>`
    /// - `<String> + <String>`
    /// - `<String> + <Object>`
    /// - `<Object> + <String>`
    /// - `<Integer> - <Integer>`
    /// - `<Integer> * <Integer>`
    /// - `<Integer> / <Integer>`
    /// - `<Integer> > <Integer>`
    /// - `<Integer> < <Integer>`
    /// - `<Integer> >= <Integer>`
    /// - `<Integer> <= <Integer>`
    /// - `<Object> == <Object>`
    /// - `<Object> != <Object>`
    /// Equality and Inequality agaist `Boolean` values will use the other value thruty or falsy
    /// representation.
    /// - Parameters:
    ///   - lhs: The left side operand expression
    ///   - operatorSymbol: The operator symbol. E.G.: +,-,*
    ///   - rhs: The right side operand expression
    /// - Throws: `UnknownOperator` if  `operatorSymbol` is not supported.
    ///           `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The result of the operation
    static func evalInfix(lhs: Object?, operatorSymbol: String, rhs: Object?) throws -> Object {
        switch operatorSymbol {
        case "+":
            return try MonkeyOperations.applyAddition(lhs: lhs, rhs: rhs)
        case "-":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: -)
        case "*":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: *)
        case "/":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: /)
        case ">":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: >)
        case "<":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: <)
        case ">=":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: >=)
        case "<=":
            return try MonkeyOperations.applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: <=)
        case "==":
            return MonkeyOperations.applyEqualInfix(lhs: lhs, rhs: rhs)
        case "!=":
            return MonkeyOperations.applyInequalityInfix(lhs: lhs, rhs: rhs)
        default:
            throw UnknownOperator(operatorSymbol)
        }
    }

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
    static func applyAddition(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs + rhs
        }

        if let string = lhs as? MString {
            return string + rhs
        }

        if let string = rhs as? MString {
            return lhs + string
        }

        throw InvalidInfixExpression("+", lhs: lhs, rhs: rhs)
    }

    /// Applies the corresponding infix operation to two `Integer` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    ///   - operation: A function to apply the operation
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `Integer`
    /// - Returns: The result of applying the `operation` if both `lhs` and `rhs` are
    ///            `Integer`. If not returns `Null`
    static func applyIntegerInfix(
        lhs: Object?,
        rhs: Object?,
        symbol: String,
        operation: (Integer, Integer) -> Object
    ) throws -> Object {
        guard let intLhs = lhs as? Integer, let intRhs = rhs as? Integer else {
            throw InvalidInfixExpression(symbol, lhs: lhs, rhs: rhs)
        }

        return operation(intLhs, intRhs)
    }

    /// Test two objects for equality
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Returns: `true` if both objects are the same, `Integer` and `Boolean` are
    ///            compared by value. Otherwise `false`
    static func applyEqualInfix(lhs: Object?, rhs: Object?) -> Boolean {
        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs == rhs
        }

        if let lhs = lhs as? MString, let rhs = rhs as? MString {
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

    /// Test two objects for inequality
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Returns: `false` if both objects are the same, `Integer` and `Boolean` are
    ///            compared by value. Otherwise `true`
    static func applyInequalityInfix(lhs: Object?, rhs: Object?) -> Boolean {
        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs != rhs
        }

        if let lhs = lhs as? MString, let rhs = rhs as? MString {
            return lhs != rhs
        }

        if let rhs = rhs as? MString {
            return lhs != rhs
        }

        if let lhs = lhs as? MString {
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
