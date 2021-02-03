//
//  OpCode.swift
//  Rosetta
//
//  Created by Franklin Cruz on 31-01-21.
//

import Foundation

/// A byte mapping to one of the operations supported by the VM
public typealias OpCode = UInt8
/// A list of bytes representing one or several or part of a VM instruction
public typealias Instructions = Array<UInt8>

public extension Instructions {
    /// Returns a human readable representations of this set of instructions
    var description: String {
        var output = ""
        var index = 0
        while index < self.count {
            guard let opCode = OpCodes(rawValue: self[index]) else {
                output += "Error: No opcode for: \(self[index])\n"
                continue
            }
            guard let def = OperationDefinition[opCode] else {
                output += "Error: No defintion for: \(self[index])\n"
                continue
            }

            let read = Bytecode.readOperands(def, instructions: Array(self[(index + 1)...]))
            let operandsString = read.values.map { $0.description }.joined(separator: ",")
            output += String(format: "%04d %@ %@", index, def.name, operandsString)
            index += 1 + read.count

            if index < self.count {
                output += "\n"
            }
        }

        return output
    }

    /// Converts this slice of instruction bytes to the swift `Int32` representation
    /// the instructions however can be of 1, 2, 3 or 4 bytes of length encoded in
    /// big endian format
    var intValue: Int32 {
        var value: Int32 = 0
        for byte in self {
            value = value << 8
            value = value | Int32(byte)
        }

        return value
    }
}

/// The operation codes supported by the VM
public enum OpCodes: OpCode {
    /// Stores a constant value in the cosntants pool
    case constant = 0x00
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
        .constant: OperationDefinition(name: "OpConstant", operandsWidth: [2])
    ]
}
