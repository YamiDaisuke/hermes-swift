//
//  MonkeyCompiler.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 01-02-21.
//

import Foundation
import Rosetta

/// Monkey Lang compiler for the Rosetta VM
struct MonkeyC: Compiler {
    typealias BaseType = Object

    var instructions: Instructions = []
    var constants: [Object] = []

    mutating func compile(_ program: Program) throws {
        for node in program.statements {
            try self.compile(node)
        }
    }

    mutating func compile(_ node: Node) throws {
        switch node {
        case let expresion as ExpressionStatement:
            try self.compile(expresion.expression)
        case let infix as InfixExpression:
            try self.compile(infix.lhs)
            try self.compile(infix.rhs)
        case let integer as IntegerLiteral:
            let value = Integer(value: integer.value)
            self.emit(.constant, operands: [self.addConstant(value)])
        default:
            break
        }
    }

    /// Saves a constant value into the constants pool
    /// - Parameter value: The value to store
    /// - Returns: The index corresponding to the stored value
    mutating func addConstant(_ value: Object) -> Int32 {
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
    mutating func emit(_ operation: OpCodes, operands: [Int32]) -> Int {
        let instruction = Bytecode.make(operation, operands: operands)
        return addInstruction(instruction)
    }
}
