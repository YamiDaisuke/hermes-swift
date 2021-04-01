//
//  MonkeyEvaluator.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation
import Hermes

public struct MonkeyEvaluator: Evaluator {
    public typealias BaseType = Object
    public typealias ControlTransfer = Return

    public static func eval(node: Node, environment: Environment<Object>) throws -> Object? {
        do {
            switch node {
            case _ as CommentStatement:
                return nil
            case let expression as ExpressionStatement:
                return try eval(node: expression.expression, environment: environment)
            case let prefix as PrefixExpression:
                let rhs = try eval(node: prefix.rhs, environment: environment)
                return try MonkeyOperations.evalPrefix(operator: prefix.operatorSymbol, rhs: rhs)
            case let infix as InfixExpression:
                let lhs = try eval(node: infix.lhs, environment: environment)
                let rhs = try eval(node: infix.rhs, environment: environment)
                return try MonkeyOperations.evalInfix(lhs: lhs, operatorSymbol: infix.operatorSymbol, rhs: rhs)
            case let ifExpression as IfExpression:
                return try evalIfExpression(ifExpression, environment: environment)
            case let block as BlockStatement:
                return try evalBlockStatement(block, environment: environment)
            case let returnStmt as ReturnStatement:
                return try evalReturnStatement(returnStmt, environment: environment)
            case let statement as IntegerLiteral:
                return Integer(statement.value)
            case let statement as BooleanLiteral:
                return statement.value ? Boolean.true : Boolean.false
            case let statement as StringLiteral:
                return MString(statement.value)
            case let declareStmt as DeclareStatement:
                let value = try eval(node: declareStmt.value, environment: environment)
                let type: VariableType = declareStmt.token.type == .let ? .let : .var
                try environment.create(declareStmt.name.value, value: value, type: type)
                return Null.null
            case let assignStmt as AssignStatement:
                let value = try eval(node: assignStmt.value, environment: environment)
                let currentType = environment.get(assignStmt.name.value)?.type
                guard currentType != nil && value?.type == currentType else {
                    throw TypeError(value?.type ?? "null", expected: currentType ?? "null")
                }
                try environment.set(assignStmt.name.value, value: value)
                return Null.null
            case let identifier as Identifier:
                return try evalIdentifier(identifier, environment: environment)
            case let function as FunctionLiteral:
                let params = function.params.map({ $0.value })
                return Function(parameters: params, body: function.body, environment: environment)
            case let call as CallExpression:
                return try evalCallExpression(call, environment: environment)
            case let array as ArrayLiteral:
                let elements = try evalExpressions(array.elements, environment: environment)
                return MArray(elements: elements)
            case let hash as HashLiteral:
                return try evalHashLiteral(hash, environment: environment)
            case let indexExpr as IndexExpression:
                return try evalIndexExpression(indexExpr, environment: environment)
            default:
                throw UnknownSyntaxToken(node)
            }
        } catch var error as EvaluatorError {
            error.line = error.line ?? node.token.line
            error.column = error.column ?? node.token.column
            error.file = error.file ?? node.token.file
            throw error
        } catch {
            throw error
        }
    }

    public static func handleControlTransfer(
        _ statement: ControlTransfer,
        environment: Environment<Object>
    ) throws -> Object? {
        // Since we only have one type of transfer control
        // we know this statement is a return wrapper
        return statement.value
    }

    /// Evals an `HashLiteral` to produce the `Hash` object
    /// - Parameters:
    ///   - expression: The litral
    ///   - environment: The current `Environment`
    /// - Throws: `EvaluatorError` if any expression fails to parse
    /// - Returns: A new `Hash` object
    static func evalHashLiteral(_ expression: HashLiteral, environment: Environment<Object>) throws -> Object? {
        var hash = Hash(pairs: [:])
        for pair in expression.pairs {
            let key = try eval(node: pair.key, environment: environment)
            let value = try eval(node: pair.value, environment: environment)
            try hash.set(key ?? Null.null, value: value ?? Null.null)
        }

        return hash
    }

    /// Evals the result of a index expression. Index expressions are in this format
    /// `<expression>[<expression>]`
    /// - Parameters:
    ///   - expression: The index expression representation
    ///   - environment: The current `Environment`
    /// - Throws: `InvalidInfixExpression` if the key or the lhs operand are not suitable for indexing
    /// - Returns: The value associated with the index
    static func evalIndexExpression(_ expression: IndexExpression, environment: Environment<Object>) throws -> Object? {
        let lhs = try eval(node: expression.lhs, environment: environment)
        let index = try eval(node: expression.index, environment: environment)

        switch lhs {
        case let array as MArray:
            guard let intIndex = index as? Integer else {
                throw InvalidInfixExpression("[]", lhs: lhs, rhs: index)
            }

            return array[intIndex]
        case let hash as Hash:
            return try hash.get(index ?? Null.null)
        default:
            throw InvalidInfixExpression("[]", lhs: lhs, rhs: index)
        }
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

    /// Evals an `Indentifer` node and returns the stored value from the current `Enviroment`
    /// or a `BuiltinFunction` if one exits with the `identifier`
    ///
    /// **Important:** `Environment` have precendence over `BuiltinFunction` in this way we can
    /// override the behaviour or `BuiltinFunction`
    ///
    /// - Parameters:
    ///   - identifier: The requested value `Identifier`
    ///   - environment: The current `Environment`
    /// - Throws: `ReferenceError` if the `Identifier` does not exists in `environment` or is a builtin function
    /// - Returns: The value asociated with `identifier`
    static func evalIdentifier(_ identifier: Identifier, environment: Environment<Object>) throws -> Object? {
        if let value = environment.get(identifier.value) {
            return value
        }

        if let value = BuiltinFunction[identifier.value] {
            return value
        }

        throw ReferenceError(identifier.value, line: identifier.token.line, column: identifier.token.column)
    }

    static func evalCallExpression(_ expression: CallExpression, environment: Environment<Object>) throws -> Object? {
        let function = try eval(node: expression.function, environment: environment)
        let args = try evalExpressions(expression.args, environment: environment)

        if let function = function as? Function {
            return try applyFunction(function, args: args)
        }

        if let function = function as? BuiltinFunction {
            return try applyBuiltinFunction(function, args: args)
        }

        throw InvalidCallExpression(function?.type ?? "Unknown")
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

    /// Applies a `BuiltinFunction` that's being called
    /// - Parameters:
    ///   - function: The `BuiltinFunction` to call
    ///   - args: The args of the `Function`
    /// - Throws: `EvaluatorError` if any expression or statement fails to be evaluated
    /// - Returns: The returning value of the `BuiltinFunction`
    static func applyBuiltinFunction(_ function: BuiltinFunction, args: [Object]) throws -> Object? {
        let evaluated = try function.function(args)
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
            try newEnv.create(name, value: value)
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
}
