//
//  TerminalController.swift
//  RosettaREPL
//
//  Created by Franklin Cruz on 28-01-21.
//

import Foundation
import TSCBasic

/// For real module operation between `Ints`
infix operator %%
public extension Int {
    /// Execute a real module operation, supporting negative and positve values
    /// - Parameters:
    ///   - lhs: The dividend
    ///   - rhs: The divisor
    /// - Returns: The unsigned reminder of the division
    static func %% (lhs: Int, rhs: Int) -> Int {
        return (lhs % rhs + rhs) % rhs
    }
}

/// Convinience constant for common special characters for terminal control
public enum Specials {
    public static let back = "\u{8}"
    public static let deleteToRight = "\(scape)[K"
    public static let scape = "\u{001B}"
    public static let clearLine = "\(scape)[2K"
    public static let clearRight = "\(scape)\(deleteToRight)"
}

public extension TerminalController {
    /// Clears all characters to the right of the cursor position
    func clearToRight() {
        self.write("\(Specials.back)\(Specials.deleteToRight)")
    }

    /// Clear the entire terminal an move the cursor to the upper left corner
    func clear() {
        self.write("\(Specials.scape)[2J\(Specials.scape)[H")
    }


    /// Moves the cursor to the left
    /// - Parameter steps: Number of positions to move. Default 1
    func moveLeft(steps: Int = 1) {
        self.write("\(Specials.scape)[\(steps)D")
    }

    /// Moves the cursor to the right
    /// - Parameter steps: Number of positions to move. Default 1
    func moveRight(steps: Int = 1) {
        self.write("\(Specials.scape)[\(steps)C")
    }

    /// Calls print function wrapped in red color modifier for terminal output
    /// - Parameter error: The object to print 
    static func printError(_ error: Any) {
        print("\u{001B}[31m\(error)\u{001B}[0m")
    }
}
