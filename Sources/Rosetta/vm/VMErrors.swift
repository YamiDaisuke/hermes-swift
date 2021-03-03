//
//  VMErrors.swift
//  Rosetta
//
//  Created by Franklin Cruz on 03-03-21.
//

import Foundation

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

/// Throw this error when a instruction byte code doesn't match with on
/// of the VM supported operations
public struct UnknownOpCode: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ code: OpCode) {
        self.message = String(format: "Unknown op code: %02X", code)
    }
}

/// Throw this when a value from the base lang is not usable as Hash key
public struct InvalidHashKey<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ key: BaseType) {
        self.message = "Value: \(key) cannot be used as hash key"
    }
}

/// Throw this when a value from the base lang is not usable as index for arrays
public struct InvalidArrayIndex<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ index: BaseType) {
        self.message = "Index \(index) can't be applied to type Array"
    }
}

/// Throw this when tryng to apply an index expression to a non-indexable value
public struct IndexNotSupported<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ value: BaseType) {
        self.message = "Can't apply index to: \(value)"
    }
}

/// Throw this when tryng to call an value that is not a function
public struct CallingNonFunction<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ value: BaseType) {
        self.message = "Calling non-function: \(value)"
    }
}
