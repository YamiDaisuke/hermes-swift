//
//  VMTypes.swift
//  Hermes
//
//  Created by Franklin Cruz on 28-03-21.
//

import Foundation

/// Use this protocol to mark the implementing language base type
public protocol VMBaseType: CustomStringConvertible, Compilable { }

/// Language agnostic representation of functions so they can be
/// executed by the VM
public protocol VMFunctionDefinition {
    /// Compiled intructions
    var instructions: Instructions { get }
    /// Number of declared local variables and constants
    var localsCount: Int { get }
    /// Number of expected parameters
    var parameterCount: Int { get }
}

/// Default `VMFunctionDefinition` implementation for internal use
struct VMFunction: VMFunctionDefinition {
    var instructions: Instructions
    var localsCount: Int
    var parameterCount: Int
}

/// Al functions on this VM are executed and wrapped as closures
public struct Closure: VMBaseType {
    /// The function to execute
    var function: VMFunctionDefinition
    /// The variables and constants captured by the closure
    var free: [VMBaseType]

    init(function: VMFunctionDefinition, free: [VMBaseType] = []) {
        self.function = function
        self.free = free
    }

    public var description: String {
        "Closure:\n\(self.function.instructions.description)"
    }
}

extension Closure: Compilable {
    public func compile() throws -> [Byte] {
        // TODO: 
        return []
    }
}
