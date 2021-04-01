//
//  Compiler.swift
//  Hermes
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

/// Holds an list of compiled instructions for one scope like a function or a closure
public class CompilationScope {
    /// Holds all the compiled instructions bytes
    var instructions: Instructions
    /// Holds the last emitted instruction
    public var lastInstruction: EmittedInstruction?
    /// Holds the previous emitted instruction
    public var prevInstruction: EmittedInstruction?

    public init() {
        instructions = []
        lastInstruction = nil
        prevInstruction = nil
    }

    /// Stores a compiled instruction
    /// - Parameter instruction: The instruction to store
    /// - Returns: The starting index of this instruction bytes
    public func addInstruction(_ instruction: Instructions) -> Int {
        let position = self.instructions.count
        self.instructions.append(contentsOf: instruction)
        return position
    }

    /// Removes the las instruction from the emmited instruction with an optional predicate
    /// - Parameter predicate: An optional predicate to choose whether or not to remove the last instruction
    ///                        if no predicate is supplied the instruction is removed
    public func removeLast(if predicate: ((EmittedInstruction) -> Bool)? = nil) {
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
    public func replaceInstructionAt(_ position: Int, with newInstruction: Instructions) {
        for index in 0..<newInstruction.count {
            self.instructions[position + index] = newInstruction[index]
        }
    }
}

/// Base Compiler structure for Hermes VM
public protocol Compiler {
    /// Keeps the compiled scopes
    var scopes: [CompilationScope] { get set }
    /// Marks the current scope being compiled
    var scopeIndex: Int { get set }
    /// Returns the current active scope
    var currentScope: CompilationScope { get }
    /// Returns the instructions compiled inside the current scope
    var currentInstructions: Instructions { get }

    /// A pool of the compiled constant values
    var constants: [VMBaseType] { get set }
    /// The compiled `SymbolTable`
    var symbolTable: SymbolTable { get set }

    /// Puts all the compiled values into a single `BytecodeProgram`
    var bytecode: BytecodeProgram { get }

    /// Traverse a parsed `Program` an creates the corresponding Bytecode
    /// - Parameter program: The program
    mutating func compile(_ program: Program) throws

    /// Traverse a parsed AST an creates the corresponding Bytecode
    /// - Parameter program: The program
    mutating func compile(_ node: Node) throws

    /// Activates a new compilation scopes
    mutating func enterScope()

    /// Closes the current compilation scope and returns the compiled instructions
    mutating func leaveScope() -> Instructions
}

public extension Compiler {
    /// Gets the current `CompilationScope`
    var currentScope: CompilationScope {
        self.scopes[self.scopeIndex]
    }

    /// Returns the instructions from the current compilation scope
    var currentInstructions: Instructions {
        self.currentScope.instructions
    }

    /// Returns the `BytecodeProgram` with all the compiled instructions
    var bytecode: BytecodeProgram {
        BytecodeProgram(instructions: self.currentInstructions, constants: self.constants)
    }

    /// Activates a new compilation scopes
    mutating func enterScope() {
        let newScope = CompilationScope()
        self.scopes.append(newScope)
        self.scopeIndex += 1

        self.symbolTable = SymbolTable(self.symbolTable)
    }

    /// Closes the current compilation scope and returns the compiled instructions
    @discardableResult
    mutating func leaveScope() -> Instructions {
        let instructions = self.currentInstructions
        _ = self.scopes.popLast()
        self.scopeIndex -= 1

        if let symbolTable = self.symbolTable.outer {
            self.symbolTable = symbolTable
        }

        return instructions
    }

    /// Saves a constant value into the constants pool
    /// - Parameter value: The value to store
    /// - Returns: The index corresponding to the stored value
    mutating func addConstant(_ value: VMBaseType) -> Int32 {
        self.constants.append(value)
        return Int32(self.constants.count - 1)
    }

    /// Converts an operation and operands into bytecode and store it
    /// - Parameters:
    ///   - operation: The operation code
    ///   - operands: The operands values
    /// - Returns: The starting index of this instruction bytes
    @discardableResult
    mutating func emit(_ operation: OpCodes, _ operands: Int32...) -> Int {
        self.currentScope.prevInstruction = self.currentScope.lastInstruction
        let instruction = Bytecode.make(operation, operands: operands)
        let position = self.currentScope.addInstruction(instruction)
        self.currentScope.lastInstruction = EmittedInstruction(operation, position: position)
        return position
    }

    /// Replace a list operands starting a given position
    /// - Parameters:
    ///   - operands: The operands to replace
    ///   - position: The position where to insert
    mutating func replaceOperands(operands: [Int32], at position: Int) {
        guard let op = OpCodes(rawValue: self.currentInstructions[position]) else {
            // TODO: Throw error
            return
        }

        let new = Bytecode.make(op, operands: operands)
        self.currentScope.replaceInstructionAt(position, with: new)
    }

    /// Checks if the last emited instructions matches a given code
    /// - Parameter code: The code to look for
    /// - Returns: `true` if the last emitted code is equals to `code`
    func lastInstructionIs(_ code: OpCodes) -> Bool {
        return self.currentScope.lastInstruction?.code == code
    }
}

/// All compilation errors should implement this protocol
public protocol CompilerError: HermesError {
}
