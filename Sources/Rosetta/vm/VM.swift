//
//  VM.swift
//  Rosetta
//
//  Created by Franklin Cruz on 03-02-21.
//

import Foundation

/// Max number of elements in the stack
let kStackSize = 2048

/// Rosetta VM implementation
public struct VM<BaseType> {
    var constants: [BaseType]
    var instructions: Instructions

    var stack: [BaseType]
    var stackPointer: Int
    
    var stackTop: BaseType? {
        guard stackPointer > 0 else { return nil }
        return stack[stackPointer - 1]
    }

    init(_ bytcode: BytecodeProgram<BaseType>) {
        self.constants = bytcode.constants
        self.instructions = bytcode.instructions
        stack = []
        stack.reserveCapacity(kStackSize)
        stackPointer = 0
    }

    public mutating func run() throws {
        var index = 0
        while index < self.instructions.count {
            let opCode = OpCodes(rawValue: instructions[index])
            switch opCode {
            case .constant:
                guard let constIndex = instructions.readInt(bytes: 2, startIndex: index + 1) else {
                    continue
                }
                index += 2
                try self.push(self.constants[Int(constIndex)])
            default:
                index += 1
            }
            index += 1
        }
    }

    mutating func push(_ object: BaseType?) throws {
        guard let object = object else { return }
        guard self.stackPointer < kStackSize else { throw StackOverflow() }

        self.stack.insert(object, at: self.stackPointer)
        self.stackPointer += 1
    }
}

/// All VM errors should implement this protocol
public protocol VMError: RosettaError {
}

/// Throw this error when a program tries to push more than `kStackSize`
/// elements into the VM stack
public struct StackOverflow: VMError {
    public var message: String = "Stack overflow"
    public var line: Int?
    public var column: Int?
    public var file: String?
}
