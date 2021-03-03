//
//  Frame.swift
//  Rosetta
//
//  Created by Franklin Cruz on 03-03-21.
//

import Foundation

/// Represents the current call frame inside the VM
public class Frame {
    /// The instructions contained in this frame
    var instructions: Instructions
    /// The current pointer position
    var instrucionPointer: Int

    /// Creates a new frame with a list of instructions
    /// - Parameter instructions: The instructions
    public init(_ instructions: Instructions) {
        self.instructions = instructions
        self.instrucionPointer = 0
    }
}
