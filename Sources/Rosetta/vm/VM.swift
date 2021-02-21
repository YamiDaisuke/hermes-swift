//
//  VM.swift
//  Rosetta
//
//  Created by Franklin Cruz on 03-02-21.
//

import Foundation

/// Max number of elements in the stack
public let kStackSize = 2048
/// Max number of global elements
public let kGlobalsSize = 65536

/// Rosetta VM implementation
public struct VM<BaseType, Operations: VMOperations> where Operations.BaseType == BaseType {
    public internal(set) var constants: [BaseType]
    var instructions: Instructions

    var operations: Operations

    var stack: [BaseType]
    var stackPointer: Int

    public internal(set) var globals: [BaseType?]

    /// Returns the current value sitting a top of the stack if the stack is empty returns `nil`
    public var stackTop: BaseType? {
        guard stackPointer > 0 else { return nil }
        return stack[stackPointer - 1]
    }

    public var lastPoped: BaseType?

    /// Creates a VM instance with an existing constants and global lists
    /// - Parameters:
    ///   - bytcode: The bytecode to run
    ///   - operations: An implementation of `VMOperations` in charge of applying the language
    ///                 specific operations for this VM
    ///   - constants: A list of existing constants
    ///   - globals: A list of existing globals 
    public init(
        _ bytcode: BytecodeProgram<BaseType>,
        operations: Operations,
        constants: inout [BaseType],
        globals: inout [BaseType?]
    ) {
        self.constants = constants
        self.instructions = bytcode.instructions
        self.operations = operations
        self.constants = constants
        self.globals = globals

        self.stack = []
        stack.reserveCapacity(kStackSize)
        stackPointer = 0
    }

    /// Init a new VM with a set of bytecode to run
    /// - Parameters:
    ///   - bytcode: The compiled bytecode
    ///   - operations: An implementation of `VMOperations` in charge of applying the language
    ///                 specific operations for this VM
    public init(_ bytcode: BytecodeProgram<BaseType>, operations: Operations) {
        var constants = bytcode.constants
        var globals: [BaseType?] = []
        globals.reserveCapacity(kGlobalsSize)
        globals.append(contentsOf: Array(repeating: nil, count: kGlobalsSize))
        self.init(
            bytcode,
            operations: operations,
            constants: &constants,
            globals: &globals
        )
    }

    /// Runs the VM against the assigned bytecode
    /// - Throws: `VMError` if anything fails while interpreting the bytecode
    public mutating func run() throws {
        var instructionPointer = 0
        while instructionPointer < self.instructions.count {
            guard let opCode = OpCodes(rawValue: instructions[instructionPointer]) else {
                throw UnknownOpCode(instructions[instructionPointer])
            }
            switch opCode {
            case .constant:
                guard let constIndex = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2
                try self.push(self.constants[Int(constIndex)])
            case .pop:
                self.pop()
            case .add, .sub, .mul, .div, .equal, .notEqual, .gt, .gte:
                let rhs = self.pop()
                let lhs = self.pop()
                let value = try operations.binaryOperation(lhs: lhs, rhs: rhs, operation: opCode)
                try self.push(value)
            case .minus, .bang:
                let rhs = self.pop()
                let value = try self.operations.unaryOperation(rhs: rhs, operation: opCode)
                try self.push(value)
            case .true, .false:
                try self.push(self.operations.getLangBool(for: opCode == .true))
            case .null:
                try self.push(self.operations.null)
            case .jumpf:
                guard let destination = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2
                let condition = self.pop()
                if !operations.isTruthy(condition) {
                    instructionPointer = Int(destination) - 1
                }
            case .jump:
                guard let destination = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2
                instructionPointer = Int(destination) - 1
            case .setGlobal:
                guard let index = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2

                if let value = self.pop() {
                    self.globals[Int(index)] = value
                }
            case .assignGlobal:
                guard let index = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2

                if let value = self.pop() {
                    self.globals[Int(index)] = value
                }
            case .getGlobal:
                guard let index = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2
                if let value = self.globals[Int(index)] {
                    try self.push(value)
                }
            case .array:
                guard let count = instructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                    continue
                }
                instructionPointer += 2
                let array = buildArray(from: self.stackPointer - Int(count), to: self.stackPointer)
                self.stackPointer -= Int(count)

                try self.push(self.operations.buildLangArray(from: array))
            default:
                break
            }
            instructionPointer += 1
        }
    }

    /// Builds an array from the stack
    /// - Parameters:
    ///   - startIndex: Initial index in the stack
    ///   - endIndex: End index in the stack
    /// - Returns: An array of the elements in the stack from start to end index
    func buildArray(from startIndex: Int, to endIndex: Int) -> [BaseType] {
        var array: [BaseType] = []
        for pointer in startIndex..<endIndex {
            array.append(self.stack[pointer])
        }
        return array
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

public struct UnknownOpCode: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ code: OpCode) {
        self.message = String(format: "Unknown op code: %02X", code)
    }
}
