//
//  Repl.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation

extension String: Error { }

struct MonkeyRepl {

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

    let welcomeMessage: String
    let prompt: String

    init(
        welcomeMessage: String = "Welcome!!!\nFeel free to type in commands\n",
        prompt: String = ">>>" ) {
        self.welcomeMessage = welcomeMessage
        self.prompt = prompt
    }

    func run() {
        print(welcomeMessage)
        while true {
            print(prompt, terminator: " ")
            let input = readLine() ?? ""
            let lexer = MonkeyLexer(withString: input)
            var parser = MonkeyParser(lexer: lexer)
            do {
                if let program = try parser.parseProgram() {
                    let result = MonkeyEvaluator.eval(program: program)
                    print(result?.description ?? "")
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

    func printError(_ error: Error) {
        print(MonkeyRepl.monkeyFace)
        print("Woops! We ran into some monkey business here!\n")
        print(error)
    }
}
