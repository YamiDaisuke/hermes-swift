//
//  OpCode.swift
//  Rosetta
//
//  Created by Franklin Cruz on 31-01-21.
//

import Foundation

/// A byte mapping to one of the operations supported by the VM
public typealias OpCode = UInt8
/// Just to make code clear 
public typealias Byte = UInt8
/// A list of bytes representing one or several or part of a VM instruction
public typealias Instructions = [Byte]

public extension Instructions {
    /// Returns a human readable representations of this set of instructions
    var description: String {
        var output = ""
        var index = 0
        while index < self.count {
            guard let opCode = OpCodes(rawValue: self[index]) else {
                output += "Error: No opcode for: \(self[index])\n"
                index += 1
                continue
            }
            guard let def = OperationDefinition[opCode] else {
                output += "Error: No defintion for: \(self[index])\n"
                index += 1
                continue
            }

            let read = Bytecode.readOperands(def, instructions: Array(self[(index + 1)...]))
            let operandsString = read.values.map { $0.description }.joined(separator: " ")
            let opName = operandsString.isEmpty ? def.name : def.name.padding(toLength: 20, withPad: " ", startingAt: 0)
            output += String(
                format: "%04d %@%@",
                index,
                opName,
                operandsString
            )
            index += 1 + read.count

            if index < self.count {
                output += "\n"
            }
        }

        return output
    }

    /// Converts a number of bytes to `Int32` representation, the taken bytes must be
    /// between 1 and 4, and reprent an int in big endian encoding
    /// - Parameter bytes: The number of bytes, Must be between 1 and 4
    /// - Returns: The `Int32` value
    func readInt(bytes: Int, startIndex: Int = 0) -> Int32? {
        guard bytes >= 1 && bytes <= 4 else {
            return nil
        }

        guard startIndex <= self.count - bytes  else {
            return nil
        }

        var value: Int32 = 0
        for byte in self[startIndex..<(startIndex + bytes)] {
            value = value << 8
            value = value | Int32(byte)
        }

        return value
    }
}

/// The operation codes supported by the VM
public enum OpCodes: OpCode {
    /// Stores a constant value in the cosntants pool
    case constant
    /// Pops the value at top of the stack
    case pop
    /// Adds the top two values in the stack 
    case add
    /// Subsctract the top two values in the stack
    case sub
    /// Multiply the top two values in the stack
    case mul
    /// Divide the top two values in the stack one by the other
    case div
    /// Push `true` into the stack
    case `true`
    /// Push `false` into the stack
    case `false`
    /// Performs an equality check
    case equal
    /// Performs an inequality check
    case notEqual
    /// Performs an greater than operation
    case gt
    /// Performs an greater than or equal operation
    case gte
    /// Performs an unary minus operation, E.G.: `-1, -10`
    case minus
    /// Performs a negation operation. E.G: `!true = false`
    case bang
    /// Jumps if the next value in the stack is `false`
    case jumpf
    /// Unconditional jump
    case jump
    /// Push the empty value representation into the stack
    case null
    /// Creates a global bound to a value
    case setGlobal
    /// Assigns a global bound to a value
    case assignGlobal
    /// Get the value assigned to a global id
    case getGlobal
    /// Creates a local bound to a value
    case setLocal
    /// Assigns a local bound to a value
    case assignLocal
    /// Get the value assigned to a local id
    case getLocal
    /// Creates an Array from the first "n" elements in the stack
    case array
    /// Creates a HashMap from the first "n" elements in the stack
    case hash
    /// Performs an index operation (subscript in Swift) E.G.: `<expression>[<expression>]`
    case index
    /// Calls/Execute a function
    case call
    /// Returns a value from a function
    case returnVal
    /// Returns an empty value from a function
    case `return`
    /// Gets a builtin function native to the implementing language
    case getBuiltin
    /// Creates a closure for a function
    case closure
    /// Get a free variable from the closure
    case getFree
    /// Push the current closure into the stack
    case currentClosure
}

/// For a clear control on the operands byte sizes
public enum Sizes: Int {
    case byte = 1 // 8 bits
    case word = 2 // 16 bits
    case dword = 4 // 32 bits
    case qword = 8 // 64 bits
}

/// Metadata `struct` to tell the compiler how the VM instructions are composed
public struct OperationDefinition {
    /// The human readable name of the operation
    public var name: String
    /// The size in bytes of each operand this operation requires
    public var operandsWidth: [Sizes]

    /// Returns the defintion associated to a given `OpCodes`
    public static subscript(_ code: OpCodes) -> OperationDefinition? {
        return definitions[code]
    }

    private static let definitions: [OpCodes: OperationDefinition] = [
        .constant: OperationDefinition(name: "OpConstant", operandsWidth: [.word]),
        .pop: OperationDefinition(name: "OpPop", operandsWidth: []),
        .add: OperationDefinition(name: "OpAdd", operandsWidth: []),
        .sub: OperationDefinition(name: "OpSub", operandsWidth: []),
        .mul: OperationDefinition(name: "OpMul", operandsWidth: []),
        .div: OperationDefinition(name: "OpDiv", operandsWidth: []),
        .true: OperationDefinition(name: "OpTrue", operandsWidth: []),
        .false: OperationDefinition(name: "OpFalse", operandsWidth: []),
        .equal: OperationDefinition(name: "OpEqual", operandsWidth: []),
        .notEqual: OperationDefinition(name: "OpNotEq", operandsWidth: []),
        .gt: OperationDefinition(name: "OpGT", operandsWidth: []),
        .gte: OperationDefinition(name: "OpGTE", operandsWidth: []),
        .minus: OperationDefinition(name: "OpMinus", operandsWidth: []),
        .bang: OperationDefinition(name: "OpBang", operandsWidth: []),
        .jumpf: OperationDefinition(name: "OpJumpFalse", operandsWidth: [.word]),
        .jump: OperationDefinition(name: "OpJump", operandsWidth: [.word]),
        .null: OperationDefinition(name: "OpNull", operandsWidth: []),
        .setGlobal: OperationDefinition(name: "OpSetGlobal", operandsWidth: [.word]),
        .assignGlobal: OperationDefinition(name: "OpAssignGlobal", operandsWidth: [.word]),
        .getGlobal: OperationDefinition(name: "OpGetGlobal", operandsWidth: [.word]),
        .setLocal: OperationDefinition(name: "OpSetLocal", operandsWidth: [.byte]),
        .assignLocal: OperationDefinition(name: "OpAssignLocal", operandsWidth: [.byte]),
        .getLocal: OperationDefinition(name: "OpGetLocal", operandsWidth: [.byte]),
        .array: OperationDefinition(name: "OpArray", operandsWidth: [.word]),
        .hash: OperationDefinition(name: "OpHash", operandsWidth: [.word]),
        .index: OperationDefinition(name: "OpIndex", operandsWidth: []),
        .call: OperationDefinition(name: "OpCall", operandsWidth: [.byte]),
        .returnVal: OperationDefinition(name: "OpReturnVal", operandsWidth: []),
        .return: OperationDefinition(name: "OpReturn", operandsWidth: []),
        .getBuiltin: OperationDefinition(name: "OpGetBuiltin", operandsWidth: [.byte]),
        .closure: OperationDefinition(name: "OpClosure", operandsWidth: [.word, .byte]),
        .getFree: OperationDefinition(name: "OpGetFree", operandsWidth: [.byte]),
        .currentClosure: OperationDefinition(name: "OpCurrentClosure", operandsWidth: [])
    ]
}
