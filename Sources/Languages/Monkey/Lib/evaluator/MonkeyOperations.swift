//
//  MonkeyOperations.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 04-02-21.
//
import Foundation

// swiftlint:disable file_length

/// Abstract operation evaluation, this will help to reduce duplicated code
/// when applying the same operations inside the Hermes VM
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
    /// - Throws: `InvalidPrefixExpression` if the operand expression is not an `Integer` or a `MFloat`
    /// - Returns: The resul of multiplying a the numeric value by -1.
    static func evalMinusPrefix(rhs: Object?) throws-> Object? {
        if let int = rhs as? Integer {
            return -int
        } else if let float = rhs as? MFloat {
            return -float
        } else {
            throw InvalidPrefixExpression("-", rhs: rhs)
        }
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
    /// - `<Integer|Float> + <Integer|Float>`
    /// - `<String> + <String>`
    /// - `<String> + <Object>`
    /// - `<Object> + <String>`
    /// - `<Integer|Float> - <Integer|Float>`
    /// - `<Integer|Float> * <Integer|Float>`
    /// - `<Integer|Float> / <Integer|Float>`
    /// - `<Integer|Float> > <Integer|Float>`
    /// - `<Integer|Float> < <Integer|Float>`
    /// - `<Integer|Float> >= <Integer|Float>`
    /// - `<Integer|Float> <= <Integer|Float>`
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
            return try MonkeyOperations.applySubstraction(lhs: lhs, rhs: rhs)
        case "*":
            return try MonkeyOperations.applyMultiplication(lhs: lhs, rhs: rhs)
        case "/":
            return try MonkeyOperations.applyDivision(lhs: lhs, rhs: rhs)
        case ">":
            return try MonkeyOperations.applyGT(lhs: lhs, rhs: rhs)
        case "<":
            return try MonkeyOperations.applyLT(lhs: lhs, rhs: rhs)
        case ">=":
            return try MonkeyOperations.applyGTE(lhs: lhs, rhs: rhs)
        case "<=":
            return try MonkeyOperations.applyLTE(lhs: lhs, rhs: rhs)
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
    /// Float + Integer
    /// Float + Float
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

        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs + rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs + rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
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

    /// Applies the substraction operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: The result of substracting the operands
    static func applySubstraction(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs - rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs - rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs - rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs - rhs
        }

        throw InvalidInfixExpression("-", lhs: lhs, rhs: rhs)
    }

    /// Applies the multiplication operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: The result of multiplyin both operands
    static func applyMultiplication(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs * rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs * rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs * rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs * rhs
        }

        throw InvalidInfixExpression("*", lhs: lhs, rhs: rhs)
    }

    /// Applies the division operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: The result of multiplyin both operands
    static func applyDivision(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs / rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs / rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs / rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs / rhs
        }

        throw InvalidInfixExpression("/", lhs: lhs, rhs: rhs)
    }

    /// Applies the greater than operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: `true` if `lhs` is greater than `rhs`
    static func applyGT(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs > rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs > rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs > rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs > rhs
        }

        throw InvalidInfixExpression(">", lhs: lhs, rhs: rhs)
    }

    /// Applies the lower than operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: `true` if `lhs` is lower than `rhs`
    static func applyLT(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs < rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs < rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs < rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs < rhs
        }

        throw InvalidInfixExpression("<", lhs: lhs, rhs: rhs)
    }

    /// Applies the greater than or equal operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: `true` if `lhs` is greater than or equal to  `rhs`
    static func applyGTE(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs >= rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs >= rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs >= rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs >= rhs
        }

        throw InvalidInfixExpression(">=", lhs: lhs, rhs: rhs)
    }

    /// Applies the lower than or equal operation to `Integer` or `MFloat` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `MFloat` or `Integer`
    /// - Returns: `true` if `lhs` is lower than or equal to  `rhs`
    static func applyLTE(lhs: Object?, rhs: Object?) throws -> Object {
        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs <= rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? Integer {
            return lhs <= rhs
        }

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs <= rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs <= rhs
        }

        throw InvalidInfixExpression("<=", lhs: lhs, rhs: rhs)
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

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs == rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs == rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
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

        if let lhs = lhs as? Integer, let rhs = rhs as? MFloat {
            return lhs != rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? Integer {
            return lhs != rhs
        }

        if let lhs = lhs as? MFloat, let rhs = rhs as? MFloat {
            return lhs != rhs
        }

        if let lhs = lhs as? MString, let rhs = rhs as? MString {
            return lhs != rhs
        }

        if let rhs = rhs as? Boolean {
            return lhs != rhs
        }

        if let lhs = lhs as? Boolean {
            return lhs != rhs
        }

        return .true
    }
}
