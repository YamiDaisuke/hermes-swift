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
import TSCUtility
import TSCBasic

enum ReplMode: String, ArgumentKind {
    init(argument: String) throws {
        switch argument {
        case "interpreted":
            self = .interpreted
        case "compiled":
            self = .compiled
        default:
            throw "Invalid mode"
        }
    }

    static var completion = ShellCompletion.values([
        ("interpreted", "Code is interpreted on the fly"),
        ("compiled", "Code is compiled and then run in the Rosetta VM")
    ])

    case interpreted
    case compiled
}

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
    let mode: ReplMode

    let welcomeMessage: String
    let prompt: String

    var controller: TerminalController?
    var stack: [String] = []
    let environment = Environment<Object>()

    init(
        mode: ReplMode = .interpreted,
        welcomeMessage: String = "Welcome!!!\nFeel free to type in commands\n",
        prompt: String = ">>>"
    ) {
        self.mode = mode
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

        var constants: [Object] = []
        var globals: [Object?] = []
        globals.reserveCapacity(kGlobalsSize)
        globals.append(contentsOf: Array(repeating: nil, count: kGlobalsSize))
        var symbolTable = SymbolTable()
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
                    switch self.mode {
                    case .interpreted:
                        let result = try MonkeyEvaluator.eval(program: program, environment: environment)
                        controller.write(result?.description ?? "", inColor: .green)
                        controller.endLine()
                    case .compiled:
                        var compiler = MonkeyC(withSymbolTable: symbolTable)
                        try compiler.compile(program)
                        constants = compiler.bytecode.constants
                        var vm = VM(
                            compiler.bytecode,
                            operations: MonkeyVMOperations(),
                            constants: &constants,
                            globals: &globals
                        )
                        try vm.run()
                        let top = vm.lastPoped
                        controller.write(top?.description ?? "", inColor: .green)
                        controller.endLine()

                        constants = vm.constants
                        globals = vm.globals
                        symbolTable = compiler.symbolTable
                    }
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
    /// - **.exit:** Closes the current session
    /// - Parameter input: The read string
    /// - Returns: `true` if `input` matches a supported command, `false` otherwise
    func replCommand(_ input: String) -> Bool {
        switch input {
        case ".env":
            print(self.environment)
            return true
        case ".exit":
            // keyReader.abort()
            exit(0)
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
