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

/// Holds the program variables states
/// this implementation is prepared to keep
/// track of outer environments like clousures
class Environment<BaseType> {
    /// Current scope variables
    var store: [String: BaseType] = [:]
    /// Outer score variables
    var outer: Environment<BaseType>?

    /// Can init this `Environment` with an outer
    /// wrapping `Environment`
    /// - Parameter outer: The outer `Environment`
    init(outer: Environment? = nil) {
        self.outer = outer
    }

    /// Gets or set a variable value
    subscript(key: String) -> BaseType? {
        /// Returns the associated value of a variable
        /// giving priority to the current scope
        get {
            return self.store[key] ?? outer?[key]
        }
        /// Sets a new variable value, if the variable exists
        /// within the current scope that  varaible is assigned
        /// if the variable does not exists in the current scope
        /// but exists in the outer one that variable is assiged.
        /// If none exists the variable is created in the current scope
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
