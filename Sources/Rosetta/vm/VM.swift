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
public struct VM<BaseType, Operations: VMOperations> where Operations.BaseType == BaseType {
    var constants: [BaseType]
    var instructions: Instructions

    var operations: Operations

    var stack: [BaseType]
    var stackPointer: Int

    /// Returns the current value sitting a top of the stack if the stack is empty returns `nil`
    public var stackTop: BaseType? {
        guard stackPointer > 0 else { return nil }
        return stack[stackPointer - 1]
    }

    public var lastPoped: BaseType?

    /// Init a new VM with a set of bytecode to run
    /// - Parameters:
    ///   - bytcode: The compiled bytecode
    ///   - operations: An implementation of `VMOperations` in charge of applying the language
    ///                 specific operations for this VM
    public init(_ bytcode: BytecodeProgram<BaseType>, operations: Operations) {
        self.constants = bytcode.constants
        self.instructions = bytcode.instructions
        self.operations = operations
        stack = []
        stack.reserveCapacity(kStackSize)
        stackPointer = 0
    }

    /// Runs the VM against the assigned bytecode
    /// - Throws: `VMError` if anything fails while interpreting the bytecode
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
            case .pop:
                self.pop()
            case .add:
                let rhs = self.pop()
                let lhs = self.pop()
                let value = try operations.add(lhs: lhs, rhs: rhs)
                try self.push(value)
            default:
                index += 1
            }
            index += 1
        }
    }

    /// Push a new element in the stack
    /// - Parameter object: The element to push
    /// - Throws: `StackOverflow` if the stack is at full capacity.
    ///           The available capacity is defined by the constant: `kStackSize`
    mutating func push(_ object: BaseType?) throws {
        guard let object = object else { return }
        guard self.stackPointer < kStackSize else { throw StackOverflow() }

        self.stack.insert(object, at: self.stackPointer)
        self.stackPointer += 1
    }

    /// Pop the element at top of the stack
    /// - Returns: The poped element
    @discardableResult
    mutating func pop() -> BaseType? {
        guard !self.stack.isEmpty else {
            self.lastPoped = nil
            return nil
        }

        let value = self.stack[self.stackPointer - 1]
        self.lastPoped = value
        self.stackPointer -= 1
        return value
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
