//
//  EvaluatorErrors.swift
//  Rosetta
//
//  Created by Franklin Cruz on 27-01-21.
//

import Foundation

/// All Evaluation errors should implement this protocol
public protocol EvaluatorError: RosettaError {
}

/// Thrown by default `Environment` implementation contained by this package
/// when trying to change the value of a constant
public struct AssignConstantError: EvaluatorError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ name: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Cannot assign to value: \"\(name)\" is a constant"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Thrown by default `Environment` implementation contained by this package
/// when trying to create a new variable o constant with an already used name
public struct RedeclarationError: EvaluatorError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ name: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Cannot redeclare: \"\(name)\" it already exists"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Thrown by default `Environment` implementation contained by this package
/// when trying to read a value not saved
public struct ReferenceError: EvaluatorError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ identifier: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "\"\(identifier)\" is not defined"
        self.line = line
        self.column = column
        self.file = file
    }
}
