//
//  MonkeyEvaluator.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation
import Rosetta

public struct MonkeyEvaluator: Evaluator {
    public typealias BaseType = Object
    public typealias ControlTransfer = Return

    public static func eval(node: Node, environment: Environment<Object>) throws -> Object? {
        do {
            switch node {
            case let expression as ExpressionStatement:
                return try eval(node: expression.expression, environment: environment)
            case let prefix as PrefixExpression:
                let rhs = try eval(node: prefix.rhs, environment: environment)
                return try evalPrefix(operator: prefix.operatorSymbol, rhs: rhs)
            case let infix as InfixExpression:
                let lhs = try eval(node: infix.lhs, environment: environment)
                let rhs = try eval(node: infix.rhs, environment: environment)
                return try evalInfix(lhs: lhs, operatorSymbol: infix.operatorSymbol, rhs: rhs)
            case let ifExpression as IfExpression:
                return try evalIfExpression(ifExpression, environment: environment)
            case let block as BlockStatement:
                return try evalBlockStatement(block, environment: environment)
            case let returnStmt as ReturnStatement:
                return try evalReturnStatement(returnStmt, environment: environment)
            case let statement as IntegerLiteral:
                return Integer(value: statement.value)
            case let statement as BooleanLiteral:
                return statement.value ? Boolean.true : Boolean.false
            case let letStmt as LetStatement:
                let value = try eval(node: letStmt.value, environment: environment)
                environment[letStmt.name.value] = value
                return Null.null
            case let identifier as Identifier:
                guard let value = environment[identifier.value] else {
                    throw ReferenceError(identifier.value, line: identifier.token.line, column: identifier.token.column)
                }
                return value
            case let function as FunctionLiteral:
                let params = function.params.map({$0.value})
                return Function(parameters: params, body: function.body, environment: environment)
            case let call as CallExpression:
                guard let function = try eval(node: call.function, environment: environment) as? Function else {
                    return nil
                }
                let args = try evalExpressions(call.args, environment: environment)

                return try applyFunction(function, args: args)
            default:
                throw UnknownSyntaxToken(node)
            }
        } catch var error as EvaluatorError {
            if error.line == nil {
                error.line = node.token.line
            }
            if error.column == nil {
                error.column = node.token.column
            }
            throw error
        } catch {
            throw error
        }
    }

    public static func handleControlTransfer(_ statement: ControlTransfer,
                                             environment: Environment<Object>) throws -> Object? {
        // Since we only have one type of transfer control
        // we know this statement is a return wrapper
        return statement.value
    }

    /// Evals a list of expression used as function arguments
    /// - Parameters:
    ///   - expressions: The list of expressions
    ///   - environment: The current `Environment`
    /// - Throws: `EvaluatorError` if any expression fails to parse
    /// - Returns: The list of `Object` resulting of each `Expression` evaluation
    static func evalExpressions(_ expressions: [Expression], environment: Environment<Object>) throws -> [Object] {
        var result: [Object] = []

        for expression in expressions {
            guard let value = try eval(node: expression, environment: environment) else {
                continue
            }

            result.append(value)
        }

        return result
    }

    /// Applies a `Function` that's being called
    /// - Parameters:
    ///   - function: The `Function` to call
    ///   - args: The args of the `Function`
    /// - Throws: `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The returning value of the `Function`
    static func applyFunction(_ function: Function, args: [Object]) throws -> Object? {
        let env = try clousureEnv(function, args: args)
        let evaluated = try eval(node: function.body, environment: env)
        if let evaluated = evaluated as? Return {
            return evaluated.value
        }
        return evaluated
    }

    /// Preparess the clousure environment for a function by apending the argument values
    /// - Parameters:
    ///   - function: The function to prepare the clousure for
    ///   - args: The args to include in the `Environment`
    /// - Throws: `WrongArgumentCount` if `function.parameters` and `args` count does not match
    /// - Returns: The clousure `Environment`
    static func clousureEnv(_ function: Function, args: [Object]) throws -> Environment<Object> {
        let newEnv = Environment(outer: function.environment)

        guard function.parameters.count == args.count else {
            throw WrongArgumentCount(function.parameters.count, got: args.count)
        }

        for index in 0..<args.count {
            let name = function.parameters[index]
            let value = args[index]
            newEnv[name] = value
        }

        return newEnv
    }

    // MARK: Statements

    /// Evals each statement of expression in a `BlockStatement`
    /// - Parameters:
    ///   - statement: The block to evaluate
    ///   - environment: The current `Environment`
    /// - Throws: `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The resulting value of the `Function`
    static func evalBlockStatement(_ statement: BlockStatement, environment: Environment<Object>) throws -> Object? {
        var result: Object? = Null.null
        for statement in statement.statements {
            result = try eval(node: statement, environment: environment)

            if result?.type == "return" {
                return result
            }
        }

        return result
    }

    /// Evals the result value of a return statement
    /// - Parameters:
    ///   - statement: The statement
    ///   - environment: The current `Environment`
    /// - Throws: `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The result of the return statement
    static func evalReturnStatement(_ statement: ReturnStatement, environment: Environment<Object>) throws -> Object? {
        let value = try eval(node: statement.value, environment: environment)
        return Return(value: value)
    }

    // MARK: Expressions

    /// Evals an if-else expression by checking the condition and executing
    /// either the if or else block
    /// - Parameters:
    ///   - expression: The `IfExpression` object
    ///   - environment: The current `Environment`
    /// - Throws: `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The resulting value of the if or else block depending on the condition
    static func evalIfExpression(_ expression: IfExpression, environment: Environment<Object>) throws -> Object? {
        let condition = try eval(node: expression.condition, environment: environment)

        if (condition == Boolean.true).value {
            return try eval(node: expression.consequence, environment: environment)
        } else if let alternative = expression.alternative {
            return try eval(node: alternative, environment: environment)
        }

        return Null.null
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

    // MARK: Infix Operators

    /// Evals operations in the form `<expression> <operator> <expression>`
    ///
    /// Supported operators:
    /// - `<Integer> + <Integer>`
    /// - `<Integer> - <Integer>`
    /// - `<Integer> * <Integer>`
    /// - `<Integer> / <Integer>`
    /// - `<Integer> > <Integer>`
    /// - `<Integer> < <Integer>`
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
    static func evalInfix(lhs: Object?, operatorSymbol: String, rhs: Object?) throws -> Object? {
        switch operatorSymbol {
        case "+":
            return try applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: +)
        case "-":
            return try applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: -)
        case "*":
            return try applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: *)
        case "/":
            return try applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: /)
        case ">":
            return try applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: >)
        case "<":
            return try applyIntegerInfix(lhs: lhs, rhs: rhs, symbol: operatorSymbol, operation: <)
        case "==":
            return applyEqualInfix(lhs: lhs, rhs: rhs)
        case "!=":
            return applyInequalityInfix(lhs: lhs, rhs: rhs)
        default:
            throw UnknownOperator(operatorSymbol)
        }
    }

    /// Applies the corresponding infix operation to two `Integer` operands
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    ///   - operation: A function to apply the operation
    /// - Throws: `InvalidInfixExpression` if the operand expressions are not `Integer`
    /// - Returns: The result of applying the `operation` if both `lhs` and `rhs` are
    ///            `Integer`. If not returns `Null`
    static func applyIntegerInfix(lhs: Object?,
                                  rhs: Object?,
                                  symbol: String,
                                  operation: (Integer, Integer) -> Object) throws -> Object? {
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

    /// Test two objects for inequality
    /// - Parameters:
    ///   - lhs: Any `Object` value
    ///   - rhs: Any `Object` value
    /// - Returns: `false` if both objects are the same, `Integer` and `Boolean` are
    ///            compared by value. Otherwise `true`
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