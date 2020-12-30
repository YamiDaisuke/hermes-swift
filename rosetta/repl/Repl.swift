//
//  Repl.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation

class Repl {
    
    var lexer: StringLexer
    let welcomeMessage: String
    let prompt: String
    
    init(lexer: StringLexer, welcomeMessage: String = "Welcome!!!\nFeel free to type in commands\n", prompt: String = ">>>" ) {
        self.lexer = lexer
        self.welcomeMessage = welcomeMessage
        self.prompt = prompt
    }
    
    func run() {
        print(welcomeMessage)
        while true {
            print(prompt, terminator: " ")
            lexer.input = readLine()
            var t = lexer.nextToken()
            while t.type != Token.Kind.eof {
                print("\t%s", t)
                t = lexer.nextToken()
            }
        }
    }
}
