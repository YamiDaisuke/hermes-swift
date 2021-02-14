//
//  Compiler.swift
//  Rosetta
//
//  Created by Franklin Cruz on 01-02-21.
//

import Foundation

/// Abstract representation of a compiler emmited instruction
public struct EmittedInstruction {
    /// The emited operation code
    public var code: OpCodes
    /// The position of this instrucction inside the instructions
    public var position: Int

    public init(_ code: OpCodes, position: Int) {
        self.code = code
        self.position = position
    }
}

/// Base Compiler structure for Rosetta VM
public protocol Compiler {
    /// The basic value type for the implementing language
    /// E.G.: In `Swift` this will be `Any`, in `C#` is `object`
    associatedtype BaseType

    /// Holds all the compiled instructions bytes
    var instructions: Instructions { get set }
    /// Holds the last emitted instruction
    var lastInstruction: EmittedInstruction? { get set }
    /// Holds the previous emitted instruction
    var prevInstruction: EmittedInstruction? { get set }

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

    /// Saves a constant value into the constants pool
    /// - Parameter value: The value to store
    /// - Returns: The index corresponding to the stored value
    mutating func addConstant(_ value: Self.BaseType) -> Int32 {
        self.constants.append(value)
        return Int32(self.constants.count - 1)
    }


    /// Stores a compiled instruction
    /// - Parameter instruction: The instruction to store
    /// - Returns: The starting index of this instruction bytes
    mutating func addInstruction(_ instruction: Instructions) -> Int {
        let position = self.instructions.count
        self.instructions.append(contentsOf: instruction)
        return position
    }

    /// Converts an operation and operands into bytecode and store it
    /// - Parameters:
    ///   - operation: The operation code
    ///   - operands: The operands values
    /// - Returns: The starting index of this instruction bytes
    @discardableResult
    mutating func emit(_ operation: OpCodes, operands: [Int32] = []) -> Int {
        self.prevInstruction = self.lastInstruction
        let instruction = Bytecode.make(operation, operands: operands)
        let position = addInstruction(instruction)
        self.lastInstruction = EmittedInstruction(operation, position: position)
        return position
    }

    /// Removes the las instruction from the emmited instruction with an optional predicate
    /// - Parameter predicate: An optional predicate to choose whether or not to remove the last instruction
    ///                        if no predicate is supplied the instruction is removed 
    mutating func removeLast(if predicate: ((EmittedInstruction) -> Bool)? = nil) {
        guard let last = self.lastInstruction else { return }
        if predicate?(last) ?? true {
            self.instructions.removeLast(1)
            self.lastInstruction = self.prevInstruction
        }
    }

    /// Replace instruction bytes starting at `position` with `newInstruction`
    /// - Parameters:
    ///   - position: The starting position to replace
    ///   - newInstruction: The new instruction bytes  
    mutating func replaceInstructionAt(_ position: Int, with newInstruction: Instructions) {
        for index in 0..<newInstruction.count {
            self.instructions[position + index] = newInstruction[index]
        }
    }

    mutating func replaceOperands(operands: [Int32], at position: Int) {
        guard let op = OpCodes(rawValue: self.instructions[position]) else {
            // TODO: Throw error
            return
        }

        let new = Bytecode.make(op, operands: operands)
        self.replaceInstructionAt(position, with: new)
    }
}

/// All compilation errors should implement this protocol
public protocol CompilerError: RosettaError {
}
