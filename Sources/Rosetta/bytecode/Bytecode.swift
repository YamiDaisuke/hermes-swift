//
//  Bytecode.swift
//  Rosetta
//
//  Created by Franklin Cruz on 31-01-21.
//

import Foundation

public enum Bytecode {
    /// Converts abstract representation into Rosetta VM bytecode instructions
    /// - Parameters:
    ///   - op: The instruction `OpCode`
    ///   - operands: The operands values
    /// - Returns: The instruction bytes
    public static func make(_ op: OpCodes, operands: [Int32] = []) -> Instructions {
        guard let defintion = OperationDefinition[op] else {
            return []
        }

        let instructionLen = 1 + defintion.operandsWidth.reduce(0, +)
        var output: Instructions = []
        output.reserveCapacity(instructionLen)
        output.append(op.rawValue)

        for index in 0..<operands.count {
            let operand = operands[index]
            let width = defintion.operandsWidth[index]
            output.append(contentsOf: withUnsafeBytes(of: operand.bigEndian, Array.init).suffix(width))
        }

        return output
    }


    /// Decodes bytecode instructions operands into `Int32` representation
    /// - Parameters:
    ///   - defintion: The expected `OperationDefinition`
    ///   - instructions: The instruction bytes
    /// - Returns: The values for the operands by combining the required bytes of each operand
    public static func readOperands(_ defintion: OperationDefinition, instructions: Instructions) -> (values: [Int32], count: Int) {
        var operands: [Int32] = []
        operands.reserveCapacity(defintion.operandsWidth.count)
        var offset = 0
        for width in defintion.operandsWidth {
            guard let int = instructions.readInt(bytes: width, startIndex: offset) else {
                continue
            }
            operands.append(int)
            offset += width
        }
        return (operands, offset)
    }
}

/// Holds a compiled program represented in bytecode
public struct BytecodeProgram<BaseType> {
    public var instructions: Instructions
    public var constants: [BaseType]
}
