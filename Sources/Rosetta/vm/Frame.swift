//
//  Frame.swift
//  Rosetta
//
//  Created by Franklin Cruz on 03-03-21.
//

import Foundation

/// Represents the current call frame inside the VM
public class Frame {
    var closure: Closure
    /// The instructions contained in this frame
    var instructions: Instructions {
        return closure.function.instructions
    }
    /// The current pointer position
    var instrucionPointer: Int
    /// Starting index for the stack pointer before the function execution
    var basePointer: Int

    /// Creates a new frame with a list of instructions
    /// - Parameter instructions: The instructions
    public init(_ closure: Closure, basePointer: Int = 0) {
        self.closure = closure
        self.instrucionPointer = 0
        self.basePointer = basePointer
    }
}
