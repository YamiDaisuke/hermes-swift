//
//  Evaluator.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation

public protocol Evaluator {
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
    static func handleControlTransfer(
        _ statement: ControlTransfer,
        environment: Environment<BaseType>
    ) throws -> BaseType?
}

public extension Evaluator {
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
public class Environment<BaseType> {
    public enum VariableType {
        case `let`
        case `var`
    }

    typealias Container = (type: VariableType, value: BaseType)

    /// Current scope variables
    var store: [String: Container] = [:]
    /// Outer score variables
    var outer: Environment<BaseType>?

    /// Can init this `Environment` with an outer
    /// wrapping `Environment`
    /// - Parameter outer: The outer `Environment`
    public init(outer: Environment? = nil) {
        self.outer = outer
    }

    /// Returns the associated value of a variable
    /// giving priority to the current scope
    /// - Parameter key: The identifier for this variable or constant
    /// - Returns: The associated value or `nil` if the variable or constant doesn't exits
    public func get(_ key: String) -> BaseType? {
        return self.store[key]?.value ?? outer?.get(key)
    }

    /// Returns the store value with the associated metadata
    /// - Parameter key: The identifier for this variable or constant
    /// - Returns: The associated value or `nil` if the variable or constant doesn't exits
    func getRaw(_ key: String) -> Container? {
        return self.store[key] ?? outer?.getRaw(key)
    }

    /// Creates a new variable or constant in this environment
    /// - Parameters:
    ///   - key: The identifier for this variable or constant
    ///   - value: The value to associate
    ///   - type: Wheter this is a variable or a constant. Default `let` I.E.: constant
    /// - Throws: `RedeclarationError` if the variable already exists
    public func create(_ key: String, value: BaseType?, type: VariableType = .let) throws {
        guard self.store[key] == nil else {
            throw RedeclarationError(key)
        }

        guard let value = value else {
            return
        }

        self.store[key] = (type: type, value: value)
    }

    /// Sets a new variable or constant value.
    ///
    /// if the variable exists within the current scope that  varaible is assigned
    /// if the variable does not exists in the current scope but exists in the outer
    /// one that variable is assiged.
    /// If the `key` references an existing constant an error is thrown
    /// - Parameters:
    ///   - key: The identifier for this variable or constant
    ///   - value: The value to associate
    ///   - type: Wheter this is a variable or a constant. Default `let` I.E.: constant
    /// - Throws: `AssignConstantError` If the `key` references an existing constant
    ///           `ReferenceError` if the `key` doesn't exists
    public func set(_ key: String, value: BaseType?, type: VariableType = .let) throws {
        if let current = self.store[key] {
            guard current.type == .var else {
                throw AssignConstantError(key)
            }

            guard let value = value else {
                self.store[key] = nil
                return
            }

            self.store[key] = (type: .var, value: value)
            return
        }

        if let current = self.outer?.getRaw(key) {
            guard current.type == .var else {
                throw AssignConstantError(key)
            }

            guard let value = value else {
                self.store[key] = nil
                return
            }

            self.store[key] = (type: .var, value: value)
            return
        }

        throw ReferenceError(key)
    }

    /// Checks if `key` exists in this `Environment`. By default only checks
    /// the inner context
    ///
    /// - Parameters:
    ///   - key: The identifier for the variable or constant
    ///   - includeOuter: Wheter to check the outer context or not. By default `false`
    /// - Returns: `true` if there is a value stored `false` otherwise
    public func contains(key: String, includeOuter: Bool = false) -> Bool {
        return store[key] != nil || (includeOuter && outer?.get(key) != nil)
    }
}
