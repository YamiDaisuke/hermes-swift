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
/// Max numbef of frames
public let kMaxFrames = 1024

// swiftlint:disable type_body_length file_length

/// Rosetta VM implementation
public struct VM<Operations: VMOperations> {
    public internal(set) var constants: [VMBaseType]

    var frames: [Frame]
    var frameIndex = 0

    var mainFunction: VMFunction
    var mainClosure: Closure

    var currentFrame: Frame {
        self.frames[self.frameIndex]
    }

    var currentInstructions: Instructions {
        self.currentFrame.instructions
    }

    var currentInstructionPointer: Int {
        get {
            return self.currentFrame.instrucionPointer
        }
        set {
            self.currentFrame.instrucionPointer = newValue
        }
    }

    var operations: Operations

    var stack: [VMBaseType]
    var stackPointer: Int

    public internal(set) var globals: [VMBaseType?]

    /// Returns the current value sitting a top of the stack if the stack is empty returns `nil`
    public var stackTop: VMBaseType? {
        guard stackPointer > 0 else { return nil }
        return stack[stackPointer - 1]
    }

    public var lastPoped: VMBaseType?

    /// Creates a VM instance with an existing constants and global lists
    /// - Parameters:
    ///   - bytcode: The bytecode to run
    ///   - operations: An implementation of `VMOperations` in charge of applying the language
    ///                 specific operations for this VM
    ///   - constants: A list of existing constants
    ///   - globals: A list of existing globals 
    public init(
        _ bytcode: BytecodeProgram,
        operations: Operations,
        constants: inout [VMBaseType],
        globals: inout [VMBaseType?]
    ) {
        self.mainFunction = VMFunction(
            instructions: bytcode.instructions,
            localsCount: 0,
            parameterCount: 0
        )

        self.mainClosure = Closure(function: self.mainFunction)

        self.constants = constants
        self.operations = operations
        self.constants = constants
        self.globals = globals

        self.stack = []
        stack.reserveCapacity(kStackSize)
        stackPointer = 0

        self.frames = []
        self.frames.reserveCapacity(kMaxFrames)
        self.frames.append(Frame(self.mainClosure))
    }

    /// Init a new VM with a set of bytecode to run
    /// - Parameters:
    ///   - bytcode: The compiled bytecode
    ///   - operations: An implementation of `VMOperations` in charge of applying the language
    ///                 specific operations for this VM
    public init(_ bytcode: BytecodeProgram, operations: Operations) {
        var constants = bytcode.constants
        var globals: [VMBaseType?] = []
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
        while self.currentInstructionPointer < self.currentInstructions.count {
            guard let opCode = OpCodes(rawValue: self.currentInstructions[self.currentInstructionPointer]) else {
                throw UnknownOpCode(self.currentInstructions[self.currentInstructionPointer])
            }

            switch opCode {
            case .constant:
                guard let constIndex = self.currentInstructions
                    .readInt(bytes: 2, startIndex: self.currentInstructionPointer + 1) else {
                    continue
                }
                self.currentInstructionPointer += 2
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
            case .jumpf, .jump:
                self.currentInstructionPointer = self.handleJumps(opCode, ip: self.currentInstructionPointer)
            case .setGlobal, .assignGlobal, .getGlobal:
                self.currentInstructionPointer = try self.handleVariables(opCode, ip: self.currentInstructionPointer)
            case .array:
                self.currentInstructionPointer = try self.handleArrays(self.currentInstructionPointer)
            case .hash:
                self.currentInstructionPointer = try self.handleHashes(self.currentInstructionPointer)
            case .index:
                try self.handleIndexOperation()
            case .call:
                try self.handleCallOperation()
                continue
            case .returnVal:
                let value = self.pop()
                self.stackPointer = self.currentFrame.basePointer - 1
                self.popFrame()
                try self.push(value)
            case .return:
                self.stackPointer = self.currentFrame.basePointer - 1
                self.popFrame()
                try self.push(self.operations.null)
            case .setLocal, .assignLocal, .getLocal:
                self.currentInstructionPointer = try self.handleLocalVariables(
                    opCode,
                    ip: self.currentInstructionPointer
                )
            case .getFree:
                self.currentInstructionPointer = try self.handleFreeVariables(
                    self.currentInstructionPointer
                )
            case .getBuiltin:
                try handleGetBuiltin()
            case .closure:
                try self.handleClosure()
            default:
                break
            }

            self.currentInstructionPointer += 1
        }
    }

    /// Push a new element in the stack
    /// - Parameter object: The element to push
    /// - Throws: `StackOverflow` if the stack is at full capacity.
    ///           The available capacity is defined by the constant: `kStackSize`
    mutating func push(_ object: VMBaseType?) throws {
        guard let object = object else { return }
        guard self.stackPointer < kStackSize else { throw StackOverflow() }

        self.stack.insert(object, at: self.stackPointer)
        self.stackPointer += 1
    }

    /// Pop the element at top of the stack
    /// - Returns: The poped element
    @discardableResult
    mutating func pop() -> VMBaseType? {
        guard !self.stack.isEmpty else {
            self.lastPoped = nil
            return nil
        }

        let value = self.stack[self.stackPointer - 1]
        self.lastPoped = value
        self.stackPointer -= 1
        return value
    }

    /// Push a new frame into our stack ready for execution
    /// - Parameter frame: The new frame
    mutating func pushFrame(_ frame: Frame) {
        self.frames.append(frame)
        self.frameIndex += 1
    }

    /// Pops the top of the frame stack an returns it
    /// - Returns: The `Frame` on top of the stack or `nil` if the stack is empty 
    @discardableResult
    mutating func popFrame() -> Frame? {
        guard let last = self.frames.popLast() else {
            return nil
        }
        self.frameIndex -= 1
        return last
    }

    // MARK: - Helper methods for op codes execution

    /// Executes both VM supported jump operations: `OpJump`, `OpJumpFalse`
    /// - Parameters:
    ///   - code: The code, which must be one of the supported jumps codes
    ///   - instructionPointer: The current instruction pointer position
    /// - Returns: The new instruction pointer after the jump is executed
    mutating func handleJumps(_ code: OpCodes, ip instructionPointer: Int) -> Int {
        var instructionPointer = instructionPointer
        switch code {
        case .jumpf:
            guard let destination = self.currentInstructions
                .readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                break
            }
            instructionPointer += 2
            let condition = self.pop()
            if !operations.isTruthy(condition) {
                instructionPointer = Int(destination) - 1
            }
        case .jump:
            guard let destination = self.currentInstructions
                .readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                break
            }
            instructionPointer += 2
            instructionPointer = Int(destination) - 1
        default:
            break
        }

        return instructionPointer
    }

    /// Executes an array creation expression
    /// - Parameter instructionPointer: The current instruction pointer position
    /// - Throws: An error if the resulting Array can't be pushed into the stack
    /// - Returns: The new instruction pointer after the array  is created
    mutating func handleArrays(_ instructionPointer: Int) throws -> Int {
        var instructionPointer = instructionPointer
        guard let count = self.currentInstructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
            return instructionPointer
        }
        instructionPointer += 2
        let array = buildArray(from: self.stackPointer - Int(count), to: self.stackPointer)
        self.stackPointer -= Int(count)

        try self.push(self.operations.buildLangArray(from: array))

        return instructionPointer
    }

    /// Executes an hash (map) creation expression
    /// - Parameter instructionPointer: The current instruction pointer position
    /// - Throws: An error if the resulting Hash can't be pushed into the stack
    /// - Returns: The new instruction pointer after the hash  is created
    mutating func handleHashes(_ instructionPointer: Int) throws -> Int {
        var instructionPointer = instructionPointer
        guard let count = self.currentInstructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
            return instructionPointer
        }
        instructionPointer += 2
        let hash = try buildHash(from: self.stackPointer - Int(count), to: self.stackPointer)
        self.stackPointer -= Int(count)

        try self.push(self.operations.buildLangHash(from: hash))

        return instructionPointer
    }

    /// Executes the declaration, assignation and reading of variable and constants
    /// - Parameters:
    ///   - opCode: One of: `OpGetGlobal`, `OpAssignglobal` or  `OpGetGlobal`
    ///   - instructionPointer: The current instruction pointer position
    /// - Throws: An error if the `OpGetGlobal` operation fails to push the value into the stack
    /// - Returns: The new instruction pointer after the operation is executed
    mutating func handleVariables(_ opCode: OpCodes, ip instructionPointer: Int) throws -> Int {
        var instructionPointer = instructionPointer
        switch opCode {
        case .setGlobal, .assignGlobal:
            guard let index = self.currentInstructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                break
            }
            instructionPointer += 2

            if let value = self.pop() {
                self.globals[Int(index)] = value
            }
        case .getGlobal:
            guard let index = self.currentInstructions.readInt(bytes: 2, startIndex: instructionPointer + 1) else {
                break
            }
            instructionPointer += 2
            if let value = self.globals[Int(index)] {
                try self.push(value)
            }
        default:
            break
        }

        return instructionPointer
    }

    /// Executes a local variable operation including declaration, assignation and reading
    /// - Parameters:
    ///   - opCode: One of: `setLocal`, `assignLocal`, `getLocal`
    ///   - instructionPointer: The current instruction pointer
    /// - Throws: A `VMError` if the operations fails
    /// - Returns: The new instruction pointer after the operation is performed
    mutating func handleLocalVariables(_ opCode: OpCodes, ip instructionPointer: Int) throws -> Int {
        var instructionPointer = instructionPointer
        switch opCode {
        case .setLocal, .assignLocal:
            guard let localIndex = self.currentInstructions
                .readInt(bytes: 1, startIndex: self.currentInstructionPointer + 1) else {
                break
            }

            instructionPointer += 1
            guard let value = self.pop() else {
                break
            }

            self.stack[self.currentFrame.basePointer + Int(localIndex)] = value
        case .getLocal:
            guard let localIndex = self.currentInstructions
                .readInt(bytes: 1, startIndex: self.currentInstructionPointer + 1) else {
                break
            }

            instructionPointer += 1

            try self.push(self.stack[self.currentFrame.basePointer + Int(localIndex)])
        default:
            break
        }

        return instructionPointer
    }

    /// Executes a local variable operation including declaration, assignation and reading
    /// - Parameters:
    ///   - opCode: One of: `setLocal`, `assignLocal`, `getLocal`
    ///   - instructionPointer: The current instruction pointer
    /// - Throws: A `VMError` if the operations fails
    /// - Returns: The new instruction pointer after the operation is performed
    mutating func handleFreeVariables(_ instructionPointer: Int) throws -> Int {
        var instructionPointer = instructionPointer

        guard let index = self.currentInstructions
            .readInt(bytes: 1, startIndex: self.currentInstructionPointer + 1) else {
            return instructionPointer
        }
        instructionPointer += 1

        let closure = self.currentFrame.closure
        try self.push(closure.free[Int(index)])

        return instructionPointer
    }

    mutating func handleClosure() throws {
        guard let constIndex = self.currentInstructions
            .readInt(bytes: 2, startIndex: self.currentInstructionPointer + 1) else {
            return
        }
        self.currentInstructionPointer += 2

        guard let free = self.currentInstructions
            .readInt(bytes: 1, startIndex: self.currentInstructionPointer + 1) else {
            return
        }
        let freeCount = Int(free)
        self.currentInstructionPointer += 1

        let function = self.constants[Int(constIndex)]

        var freeVars: [VMBaseType] = []
        freeVars.reserveCapacity(freeCount)

        for index in 0..<freeCount {
            freeVars.append(self.stack[self.stackPointer - freeCount + index])
        }
        self.stackPointer -= freeCount

        guard let decoded = self.operations.decodeFunction(function) else {
            return
        }
        let closure = Closure(function: decoded, free: freeVars)
        try self.push(closure)
    }

    /// Executes a function call operation, using an execution frame and stack for variables
    /// - Throws:`CallingNonFunction` if the called variable is not a function
    mutating func handleCallOperation() throws {
        guard let numArgs = self.currentInstructions
            .readInt(bytes: 1, startIndex: self.currentInstructionPointer + 1) else {
            return
        }
        self.currentInstructionPointer += 1

        let function = self.stack[self.stackPointer - 1 - Int(numArgs)]

        let args = Array(self.stack[(self.stackPointer - Int(numArgs))..<self.stackPointer])
        if let output = try self.operations.executeBuiltinFunction(function, args: args) {
            self.stackPointer -= Int(numArgs) - 1
            self.currentInstructionPointer += 1
            try self.push(output)
            return
        }

        guard let decoded = function as? Closure else {
            throw CallingNonFunction(function)
        }

        guard decoded.function.parameterCount == numArgs else {
            throw WrongArgumentCount(decoded.function.parameterCount, got: Int(numArgs))
        }

        let frame = Frame(
            decoded,
            basePointer: self.stackPointer - Int(numArgs)
        )
        self.pushFrame(frame)
        self.stackPointer = frame.basePointer + decoded.function.localsCount
        self.stack.append(
            // TODO: Append the right number 
            contentsOf: Array(repeating: self.operations.null, count: decoded.function.localsCount)
        )
    }

    /// Puts the definition of a builtin function into the stack
    /// - Throws: A `VMError` if the operations fails
    mutating func handleGetBuiltin() throws {
        guard let functionIndex = self.currentInstructions
            .readInt(bytes: 1, startIndex: self.currentInstructionPointer + 1) else {
            return
        }

        self.currentInstructionPointer += 1

        guard let function = self.operations.getBuiltinFunction(Int(functionIndex)) else {
            return
        }

        try self.push(function)
    }

    /// Executes an index operation for the VM, the result and limitations
    /// will depend on the underlyng language
    ///
    /// ```
    /// <expresion>[<expression>]
    /// ```
    /// - Throws: A `VMError` if the operation is invalid
    mutating func handleIndexOperation() throws {
        guard let index = self.pop() else { return }
        guard let lhs = self.pop() else { return }

        let value = try self.operations.executeIndexExpression(lhs, index: index)
        try self.push(value)
    }

    /// Builds an array from the stack
    /// - Parameters:
    ///   - startIndex: Initial index in the stack
    ///   - endIndex: End index in the stack
    /// - Returns: An array of the elements in the stack from start to end index
    func buildArray(from startIndex: Int, to endIndex: Int) -> [VMBaseType] {
        var array: [VMBaseType] = []
        for pointer in startIndex..<endIndex {
            array.append(self.stack[pointer])
        }
        return array
    }

    /// Builds an hashtable from the stack
    /// - Parameters:
    ///   - startIndex: Initial index in the stack
    ///   - endIndex: End index in the stack
    /// - Throws: `InvalidHashKey` if the value provided as key is not hashable
    /// - Returns: An hashtable of the elements in the stack from start to end index
    func buildHash(from startIndex: Int, to endIndex: Int) throws -> [AnyHashable: VMBaseType] {
        var output: [AnyHashable: VMBaseType] = [:]

        for pointer in stride(from: startIndex, to: endIndex, by: 2) {
            // We can asume the underlying language should implement types
            // that conform to AnyHashable
            // TODO: Supress warning
            guard let key = self.stack[pointer] as? AnyHashable else {
                throw InvalidHashKey(self.stack[pointer])
            }

            let value = self.stack[pointer + 1]
            output[key] = value
        }

        return output
    }
}
