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
            let operandsString = read.values.map { $0.description }.joined(separator: ",")
            output += String(
                format: "%04d %@%@",
                index,
                def.name,
                operandsString.isEmpty ? operandsString : " " + operandsString
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
}

/// Metadata `struct` to tell the compiler how the VM instructions are composed
public struct OperationDefinition {
    /// The human readable name of the operation
    public var name: String
    /// The size in bytes of each operand this operation requires
    public var operandsWidth: [Int]

    /// Returns the defintion associated to a given `OpCodes`
    public static subscript(_ code: OpCodes) -> OperationDefinition? {
        return definitions[code]
    }

    private static let definitions: [OpCodes: OperationDefinition] = [
        .constant: OperationDefinition(name: "OpConstant", operandsWidth: [2]),
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
        .gte: OperationDefinition(name: "OpGTE", operandsWidth: [])
    ]
}
