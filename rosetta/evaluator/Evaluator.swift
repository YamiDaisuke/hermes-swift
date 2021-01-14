//
//  Evaluator.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation

/// All Evaluation errors should implement this protocol
protocol EvaluatorError: Error, CustomStringConvertible {
    var message: String { get }
    var line: Int? { get set }
    var column: Int? { get set }
}

extension EvaluatorError {
    var description: String {
        var output = self.message
        if let line = line, let col = column {
            output += " at Line: \(line), Column: \(col)"
        }
        return output
    }
}

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

    static func eval(program: Program, environment: Environment<BaseType>) throws -> BaseType?
    static func eval(node: Node, environment: Environment<BaseType>) throws -> BaseType?

    /// Evaluates `ControlTransfer` wrapper and generates the corresponding output
    /// - Parameter statement: Some `ControlTransfer` statement wrapper like `return` or
    ///                        `break` statements
    static func handleControlTransfer(_ statement: ControlTransfer,
                                      environment: Environment<BaseType>) throws -> BaseType?
}

extension Evaluator {
    static func eval(program: Program, environment: Environment<BaseType>) throws -> BaseType? {
        var result: BaseType?
        for statement in program.statements {
            result = try Self.eval(node: statement, environment: environment)

            if let result = result as? ControlTransfer {
                return try handleControlTransfer(result, environment: environment)
            }
        }

        return result
    }
}

class Environment<BaseType> {
    var store: [String: BaseType] = [:]
    var outer: Environment<BaseType>?

    init(outer: Environment? = nil) {
        self.outer = outer
    }

    subscript(key: String) -> BaseType? {
        get {
            return self.store[key] ?? outer?[key]
        }
        set(newValue) {
            if self.store[key] != nil {
                self.store[key] = newValue
                return
            }

            if self.outer?[key] != nil {
                self.outer?[key] = newValue
                return
            }

            self.store[key] = newValue
        }
    }
}
