//
//  Function.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation
import Hermes

/// Represents any function from the MonkeyLanguage
/// `Function` instances can be called and executed
/// at any point by having an identifier pointing to it.
/// Or by explicity calling it at the moment of declaration
public struct Function: Object {
    public static var type: ObjectType { "function" }
    public var parameters: [String]
    var body: BlockStatement
    /// This will be a reference to the function outer environment
    public var environment: Environment<Object>

    public var description: String {
        "fn(\(parameters.joined(separator: ", "))) \(body)"
    }

    public func isEquals(other: Object) -> Bool {
        guard let otherFn = other as? Function else { return false }
        return otherFn.description == self.description
    }
}

/// Same as `Function` but represented with compiled bytecode instructions
public struct CompiledFunction: Object, VMFunctionDefinition {
    public static var type: ObjectType { "compiledFunction" }
    /// If the function is asigned to a name we keep it here
    /// for better bytecode analysis 
    public var name: String?

    public var instructions: Instructions
    public var localsCount: Int
    public var parameterCount: Int

    public init(instructions: Instructions, localsCount: Int = 0, parameterCount: Int = 0) {
        self.instructions = instructions
        self.localsCount = localsCount
        self.parameterCount = parameterCount
    }

    /// A string representation of the bytecode
    public var description: String {
        """
        Name: \(name ?? "anonymous")
        Instructions:
        \(instructions.description.indented())
        Locals Count: \(localsCount)
        Parameter Count: \(parameterCount)
        """
    }

    public func isEquals(other: Object) -> Bool {
        guard let otherFn = other as? CompiledFunction else { return false }
        // Keep this for easier debuging
        print("==== Self\n\(self.instructions.description)\n====")
        print("==== Other\n\(otherFn.instructions.description)\n====")
        return otherFn.instructions == self.instructions
    }
}
