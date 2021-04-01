//
//  SymbolTable.swift
//  Rosetta
//
//  Created by Franklin Cruz on 20-02-21.
//

import Foundation

/// Assigned scope for compiled symbols
public enum Scope: CustomStringConvertible {
    case global
    case local
    case builtin
    case free
    case function

    public var description: String {
        switch self {
        case .global:
            return "global"
        case .local:
            return "local"
        case .builtin:
            return "builtin"
        case .free:
            return "free"
        case .function:
            return "function"
        }
    }
}

/// Abstract representation of a compiled symbol
/// can be used to generate debug symbols
public struct Symbol {
    /// The identifer for the symbol
    public var name: String
    /// Which scope this symbol belongs to
    public var scope: Scope
    /// The index of the symbol inside the value table
    public var index: Int
    /// Wheter this symbol is a `let` or a `var`
    public var type: VariableType

    public init(name: String, scope: Scope, index: Int, type: VariableType = .let) {
        self.name = name
        self.scope = scope
        self.index = index
        self.type = type
    }
}

extension Symbol: Equatable {
}

/// Holds a list of compiled symbols
public class SymbolTable: NSObject {
    /// Maps symbols metadata to the assigned name
    var store: [String: Symbol] = [:]
    /// How many symbols this table contains
    public var totalDefinitions: Int = 0

    /// Outer closure scope
    var outer: SymbolTable?

    /// Free values captured by closure
    public var freeSymbols: [Symbol] = []

    /// Default init
    public override init() { }

    /// Creates a new `SymbolTable` from a base outer scope
    public init(_ outer: SymbolTable) {
        self.outer = outer
    }

    /// Defines a new symbol with the given name
    /// - Parameters:
    ///     - name: The name/identifier of the symbol
    ///     - type: Define if this symbol is a constant or a variable
    /// - Throws: `RedeclarationError` if `name` is  already in this table
    /// - Returns: The newly created symbol
    @discardableResult
    public func define(_ name: String, type: VariableType = .let) throws -> Symbol {
        // We should only check redeclaratins in the local table
        // it is perfectly valid to redeclare a global variable
        // in the local scope
        guard self.store[name] == nil || self.store[name]?.scope == .function  else {
            throw RedeclarationError(name)
        }
        let scope: Scope = self.outer == nil ? .global : .local
        let symbol = Symbol(name: name, scope: scope, index: self.totalDefinitions, type: type)
        self.store[name] = symbol
        self.totalDefinitions += 1
        return symbol
    }

    /// Defines a new builtin symbol with the given name
    /// - Parameters:
    ///     - name: The name/identifier of the symbol
    ///     - index: The value index in this table
    /// - Throws: `RedeclarationError` if `name` is  already in this table
    /// - Returns: The newly created symbol
    @discardableResult
    public func defineBuiltin(_ name: String, index: Int) throws -> Symbol {
        // We should only check redeclaratins in the local table
        // it is perfectly valid to redeclare a global variable
        // in the local scope
        guard self.store[name] == nil || self.store[name]?.scope == .function else {
            throw RedeclarationError(name)
        }

        let symbol = Symbol(name: name, scope: .builtin, index: index, type: .let)
        self.store[name] = symbol
        return symbol
    }

    /// Defines a new free symbol with the given name
    /// - Parameters:
    ///     - original: A symbol to convert into a free variable for the closure
    /// - Throws: `RedeclarationError` if `name` is  already in this table
    /// - Returns: The newly created symbol
    @discardableResult
    public func defineFree(from original: Symbol) throws -> Symbol {
        // We should only check redeclaratins in the local table
        // it is perfectly valid to redeclare a global variable
        // in the local scope
        guard self.store[original.name] == nil || self.store[original.name]?.scope == .function else {
            throw RedeclarationError(original.name)
        }

        self.freeSymbols.append(original)

        let symbol = Symbol(
            name: original.name,
            scope: .free,
            index: self.freeSymbols.count - 1,
            type: .let
        )

        self.store[original.name] = symbol
        return symbol
    }

    /// Defines the function name in the current scope this only applies if the
    /// current function is being assigned into a named variable or constant
    /// - Parameters:
    ///     - name: The name/identifier of the function
    /// - Throws: `RedeclarationError` if `name` is  already in this table
    /// - Returns: The newly created symbol
    @discardableResult
    public func defineFunctionName(_ name: String) throws -> Symbol {
        let symbol = Symbol(name: name, scope: .function, index: 0)
        self.store[name] = symbol
        return symbol
    }

    /// Resolves a name/identifier into a symbol
    /// - Parameter name: The name/identifier to resolve
    /// - Throws: `CantResolveName` if `name` is not registerd in this table
    /// - Returns: The `Symbol` assigned to `name`
    public func resolve(_ name: String) throws -> Symbol {
        // First check for a local value
        if let symbol = self.store[name] {
            return symbol
        }

        // If we have an outer `SymbolTable` check for the
        // value in there
        if let outer = self.outer {
            let value = try outer.resolve(name)

            if value.scope == .global || value.scope == .builtin {
                return value
            }

            return try self.defineFree(from: value)
        }

        // If both previous steps fails throw an error
        throw CantResolveName(name)
    }

    public override var description: String {
        "\(self.store.map { "\($0.key): \($0.value.index),\($0.value.scope)" }.joined(separator: "\n"))"
    }
}

/// Throw this if a name does not exists in the symbol table
public struct CantResolveName: CompilerError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ name: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Name \"\(name)\" not resolvable"
        self.line = line
        self.column = column
        self.file = file
    }
}
