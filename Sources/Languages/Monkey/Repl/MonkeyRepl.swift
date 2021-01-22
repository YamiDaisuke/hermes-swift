//
//  Repl.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation
import Rosetta
import MonkeyLang

/*
 func getKeyPress () -> Int {
     var key: Int = 0
     var char: cc_t = 0
     let cct = (
         char, char, char, char, char,
         char, char, char, char, char,
         char, char, char, char, char,
         char, char, char, char, char
     ) // Set of 20 Special Characters
     var oldt = termios(c_iflag: 0, c_oflag: 0, c_cflag: 0, c_lflag: 0, c_cc: cct, c_ispeed: 0, c_ospeed: 0)

     tcgetattr(STDIN_FILENO, &oldt) // 1473
     var newt = oldt
     newt.c_lflag = 1217  // Reset ICANON and Echo off
     tcsetattr( STDIN_FILENO, TCSANOW, &newt)
     key = Int(getchar())  // works like "getch()"
     tcsetattr( STDIN_FILENO, TCSANOW, &oldt)
     return key
 }
 */

struct MonkeyRepl {
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

    init(
        welcomeMessage: String = "Welcome!!!\nFeel free to type in commands\n",
        prompt: String = ">>>"
    ) {
        self.welcomeMessage = welcomeMessage
        self.prompt = prompt
    }

    func run() {
        print(welcomeMessage)
        let environment = Environment<Object>()
        while true {
            print(prompt, terminator: " ")
            let input = readLine() ?? ""
            let lexer = MonkeyLexer(withString: input)
            var parser = MonkeyParser(lexer: lexer)
            do {
                if let program = try parser.parseProgram() {
                    let result = try MonkeyEvaluator.eval(program: program, environment: environment)
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
