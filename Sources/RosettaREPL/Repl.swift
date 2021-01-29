//
//  Repl.swift
//  RosettaREPL
//
//  Created by Franklin Cruz on 28-01-21.
//

import Foundation
import TSCBasic

/// Base protocl for REPL tool implementations
public protocol Repl {
    /// A friendly welcome message for our users
    var welcomeMessage: String { get }
    /// The prompt sequence to read input
    var prompt: String { get }

    /// We use `TerminalController` to manipulate the terminal input
    var controller: TerminalController? { get }
    /// Store here the previous comands so the user can navigate his history
    var stack: [String] { get set }

    /// Runs the REPL
    mutating func run()
    /// Handle the user input
    /// - Returns: The input string
    func readInput() -> String
    /// Prints friendly error representations
    /// - Parameter error: The `Error` to print
    func printError(_ error: Error)
}

public extension Repl {

    /// Handle the user input
    ///
    /// - Currently the input can be edited by using left and right arrow keys,
    /// up and down keys allow navigation in the input stack.
    /// - Backspace and delete works as expected.
    /// - ctrl+L will clear the terminal and the current typed command
    /// **Only tested on macOS iTerm**
    /// - Returns: The input string
    func readInput() -> String {
        guard let controller = self.controller else {
            return ""
        }
        let keyReader = KeyReader()
        var buffer: [Character] = []
        var stackPointer = -1
        while true {
            buffer = []
            controller.write("\(prompt) ", inColor: .cyan, bold: true)
            var cursor = 0
            var reading = true
            var clear = false
            while reading {
                keyReader.subscribe { event in
                    switch event {
                    case .down:
                        guard !stack.isEmpty else { return }
                        stackPointer = (stackPointer - 1) %% stack.count
                        controller.write("\(Specials.clearLine)\r\(prompt) ", inColor: .cyan, bold: true)
                        controller.write(stack[stack.count - stackPointer - 1])
                        buffer = Array(stack[stack.count - stackPointer - 1])
                        cursor = buffer.count
                    case .up:
                        guard !stack.isEmpty else { return }
                        stackPointer = (stackPointer + 1) %% stack.count
                        controller.write("\(Specials.clearLine)\r\(prompt) ", inColor: .cyan, bold: true)
                        controller.write(stack[stack.count - stackPointer - 1])
                        buffer = Array(stack[stack.count - stackPointer - 1])
                        cursor = buffer.count
                    case .left:
                        guard cursor > 0 else { return }
                        controller.moveLeft()
                        cursor = min(max(0, cursor - 1), buffer.count - 1)
                    case .right:
                        guard cursor < buffer.count else { return }
                        controller.moveRight()
                        cursor = min(max(0, cursor + 1), buffer.count)
                    case .ascii(let char):
                        handleAscii(char, cursor: &cursor, buffer: &buffer, controller: controller)
                    case .enter:
                        reading = false
                    case .backspace:
                        handleBackspace(cursor: &cursor, buffer: &buffer, controller: controller)
                    case .delete:
                        handleDelete(cursor: &cursor, buffer: &buffer, controller: controller)
                    case .clear:
                        controller.clear()
                        reading = false
                        clear = true
                    case .unknow:
                        controller.write("")
                        reading = false
                    }
                }
            }

            if clear { continue }

            controller.endLine()

            return String(buffer)
        }
    }

    private func handleAscii(_ char: Character, cursor: inout Int, buffer: inout [Character], controller: TerminalController) {
        buffer.insert(char, at: cursor)
        cursor += 1
        if cursor < buffer.count {
            controller.write("\(char)\(Specials.deleteToRight)\(String(buffer[cursor...]))")
            controller.moveLeft(steps: buffer.count - cursor)
        } else {
            controller.write(String(char))
        }
    }

    private func handleBackspace(cursor: inout Int, buffer: inout [Character], controller: TerminalController) {
        guard !buffer.isEmpty && cursor > 0 else { return }
        cursor -= 1
        if cursor < buffer.count - 1 {
            buffer.remove(at: cursor)
            let string = String(buffer[cursor...])
            controller.write(
                "\(Specials.back)\(Specials.scape)7\(Specials.deleteToRight)\(string)\(Specials.scape)8"
            )
        } else {
            buffer.removeLast()
            controller.clearToRight()
        }
    }

    private func handleDelete(cursor: inout Int, buffer: inout [Character], controller: TerminalController) {
        guard !buffer.isEmpty else { return }
        if cursor < buffer.count {
            buffer.remove(at: cursor)
            let string = String(buffer[cursor...])
            controller.write(
                "\(Specials.scape)7\(Specials.deleteToRight)\(string)\(Specials.scape)8"
            )
        }
    }
}
