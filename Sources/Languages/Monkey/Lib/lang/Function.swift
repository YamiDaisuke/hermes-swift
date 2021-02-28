//
//  Function.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation
import Rosetta

/// Represents any function from the MonkeyLanguage
/// `Function` instances can be called and executed
/// at any point by having an identifier pointing to it.
/// Or by explicity calling it at the moment of declaration
public struct Function: Object {
    public var type: ObjectType { "function" }
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
public struct CompiledFunction: Object {
    public var type: ObjectType { "compiledFunction" }

    public var instructions: Instructions

    public var description: String {
        "CompiledFunction:\n\(instructions.description)"
    }

    public func isEquals(other: Object) -> Bool {
        guard let otherFn = other as? CompiledFunction else { return false }
        // Keep this for easier debuging
        print("==== Self\n\(self.instructions.description)\n====")
        print("==== Other\n\(otherFn.instructions.description)\n====")
        return otherFn.instructions == self.instructions
    }
}
