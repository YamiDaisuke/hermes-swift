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

    public var description: String {
        switch self {
        case .global:
            return "global"
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
public struct SymbolTable: CustomStringConvertible {
    /// Maps symbols metadata to the assigned name
    var store: [String: Symbol] = [:]
    /// How many symbols this table contains
    var totalDefinitions: Int {
        return store.count
    }

    public init() { }

    /// Defines a new symbol with the given name
    /// - Parameters:
    ///     - name: The name/identifier of the symbol
    ///     - type: Define if this symbol is a constant or a variable
    /// - Throws: `RedeclarationError` if `name` is not already in this table
    /// - Returns: The newly created symbol
    @discardableResult
    public mutating func define(_ name: String, type: VariableType = .let) throws -> Symbol {
        guard self.store[name] == nil else {
            throw RedeclarationError(name)
        }

        let symbol = Symbol(name: name, scope: .global, index: self.totalDefinitions, type: type)
        self.store[name] = symbol
        return symbol
    }

    /// Resolves a name/identifier into a symbol
    /// - Parameter name: The name/identifier to resolve
    /// - Throws: `CantResolveName` if `name` is not registerd in this table
    /// - Returns: The `Symbol` assigned to `name`
    public func resolve(_ name: String) throws -> Symbol {
        guard let symbol = self.store[name] else {
            throw CantResolveName(name)
        }

        return symbol
    }

    public var description: String {
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
