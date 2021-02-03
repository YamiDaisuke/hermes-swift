//
//  Compiler.swift
//  Rosetta
//
//  Created by Franklin Cruz on 01-02-21.
//

import Foundation

/// Base Compiler structure for Rosetta VM
public protocol Compiler {
    /// The basic value type for the implementing language
    /// E.G.: In `Swift` this will be `Any`, in `C#` is `object`
    associatedtype BaseType

    /// Holds all the compiled instructions bytes
    var instructions: Instructions { get set }
    /// A pool of the compiled constant values
    var constants: [BaseType] { get set }

    /// Puts all the compiled values into a single `BytecodeProgram`
    var bytecode: BytecodeProgram<BaseType> { get }

    /// Traverse a parsed `Program` an creates the corresponding Bytecode
    /// - Parameter program: The program
    mutating func compile(_ program: Program) throws

    /// Traverse a parsed AST an creates the corresponding Bytecode
    /// - Parameter program: The program
    mutating func compile(_ node: Node) throws
}

public extension Compiler {
    /// Returns the `BytecodeProgram` with all the compiled instructions 
    var bytecode: BytecodeProgram<Self.BaseType> {
        BytecodeProgram(instructions: self.instructions, constants: self.constants)
    }
}
