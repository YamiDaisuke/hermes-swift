//
//  Repl.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation
import Rosetta
import MonkeyLang
import RosettaREPL
import TSCBasic

struct MonkeyRepl: Repl {
    // swiftlint:disable indentation_width
    static let monkeyFace: String = #"""
                __,__
       .--.  .-"     "-.  .--.
      / .. \/  .-. .-.  \/ .. \
     | |  '|  /   Y   \  |'  | |
     | \   \  \ 0 | 0 /  /   / |
      \ '- ,\.-"`` ``"-./, -' /
       `'-' /_   ^ ^   _\ '-'`
           |  \._   _./  |
           \   \ `~` /   /
            '._ '-=-' _.'
               '~---~'
    """#
    // swiftlint:enable indentation_width
    let welcomeMessage: String
    let prompt: String

    var controller: TerminalController?
    var stack: [String] = []
    let environment = Environment<Object>()

    init(
        welcomeMessage: String = "Welcome!!!\nFeel free to type in commands\n",
        prompt: String = ">>>"
    ) {
        self.welcomeMessage = welcomeMessage
        self.prompt = prompt
        self.controller = TerminalController(stream: stdoutStream)
    }

    /// REPL loop exectution 
    mutating func run() {
        print(welcomeMessage)
        guard let controller = controller  else {
            return
        }

        while true {
            let input = self.readInput()

            guard !replCommand(input) else {
                continue
            }

            stack.append(input)
            let lexer = MonkeyLexer(withString: input)
            var parser = MonkeyParser(lexer: lexer)
            do {
                if let program = try parser.parseProgram() {
                    let result = try MonkeyEvaluator.eval(program: program, environment: environment)
                    controller.write(result?.description ?? "", inColor: .green)
                    controller.endLine()
                } else {
                    throw "Program not parsed"
                }
            } catch let error as AllParserError {
                printError(error)
            } catch {
                printError(error)
            }
        }
    }

    /// Activate commands specific to this REPL tool
    ///
    /// Current commands:
    /// - **.env:** Prints the current values stored in the `Environment`
    /// - Parameter input: The read string
    /// - Returns: `true` if `input` matches a supported command, `false` otherwise
    func replCommand(_ input: String) -> Bool {
        switch input {
        case ".env":
            print(self.environment)
            return true
        default:
            return false
        }
    }

    /// Prints errors nicely
    /// - Parameter error: Catched `Error`
    func printError(_ error: Error) {
        guard let controller = controller  else {
            return
        }

        controller.write(MonkeyRepl.monkeyFace, inColor: .red)
        controller.endLine()
        controller.write("Woops! We ran into some monkey business here!\n", inColor: .red)
        controller.write("\(error)", inColor: .red)
        controller.endLine()
    }
}
