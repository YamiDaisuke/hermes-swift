//
//  Lexer.swift
//  rossetta
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation

class Lexer {
    let filePath: URL?
    let input: String?
    
    private var currentLineNumber = 0
    private(set) var currentColumn = 0
    private var nextColumn = 0
    
    private var currentLine: String? = nil
    
    init(withFilePath filePath: URL) {
        self.filePath = filePath
        self.input = nil
    }
    
    init(withString input: String) {
        self.input = input
        self.filePath = nil
    }
    
    func nextToken() -> Token {
        var token: Token = Token(type: .eof, literal: "")
        
        guard let input = self.input else {
            return token
        }
        
        self.skipWhitespace()
        
        guard self.currentColumn < input.count else {
            return token
        }
        
        let currentIndex = input.index(input.startIndex, offsetBy: self.currentColumn)
        
        
        let char = input[currentIndex]
        
        var next = ""
        if (self.currentColumn + 1) < input.count {
            let nextIndex = input.index(input.startIndex, offsetBy: self.currentColumn + 1)
            next = String(input[nextIndex])
        }
        
        switch char {
        case "=":
            if next == "=" {
                token = Token(type: .equals, literal: String(char) + next)
                self.currentColumn += 1
            } else {
                token = Token(type: .assign, literal: String(char))
            }
        case "+":
            token = Token(type: .plus, literal: String(char))
        case "-":
            token = Token(type: .minus, literal: String(char))
        case "!":
            if next == "=" {
                token = Token(type: .notEquals, literal: String(char) + next)
                self.currentColumn += 1
            } else {
                token = Token(type: .bang, literal: String(char))
            }
        case "*":
            token = Token(type: .asterisk, literal: String(char))
        case "/":
            token = Token(type: .slash, literal: String(char))
        case "<":
            if next == "=" {
                token = Token(type: .lte, literal: String(char) + next)
                self.currentColumn += 1
            } else {
                token = Token(type: .lt, literal: String(char))
            }
        case ">":
            if next == "=" {
                token = Token(type: .gte, literal: String(char) + next)
                self.currentColumn += 1
            } else {
                token = Token(type: .gt, literal: String(char))
            }
        case ";":
            token = Token(type: .semicolon, literal: String(char))
        case "(":
            token = Token(type: .lparen, literal: String(char))
        case ")":
            token = Token(type: .rparen, literal: String(char))
        case ",":
            token = Token(type: .comma, literal: String(char))
        case "{":
            token = Token(type: .lbrace, literal: String(char))
        case "}":
            token = Token(type: .rbrace, literal: String(char))
        default:
            if char.isIdentifierLetter {
                let literal = self.readIdentifier()
                let type: Token.Kind = Token.Kind.keywords.contains(literal) ? literal : .identifier
                return Token(type: type, literal: literal)
            } else if char.isNumber {
                let literal = self.readNumber()
                return Token(type: .int, literal: literal)
            }
            token = Token(type: .ilegal, literal: String(char))
        }
        
        self.currentColumn += 1
        return token
    }
    
    private func readLine() {
        // TODO:
    }
    
    internal func skipWhitespace() {
        guard let input = self.input else {
            return
        }
        
        let startIndex = self.currentColumn
        var steps = 0
        for char in String(input[startIndex...]) {
            if char.isWhitespace {
                steps += 1
            } else {
                break
            }
        }
        
        self.currentColumn += steps
    }
    
    internal func readIdentifier() -> String {
        guard let input = self.input else {
            return ""
        }
        
        let startIndex = self.currentColumn
        var steps = 0
        for char in input[self.currentColumn...] {
            if char.isIdentifierLetter {
                steps += 1
            } else {
                break
            }
        }
        
        self.currentColumn += steps
        return String(input[startIndex..<self.currentColumn])
    }
    
    internal func readNumber() -> String {
        guard let input = self.input else {
            return ""
        }
        
        let startIndex = self.currentColumn
        var steps = 0
        for char in input[startIndex...] {
            if char.isNumber {
                steps += 1
            } else {
                break
            }
        }
        
        self.currentColumn += steps
        return String(input[startIndex..<self.currentColumn])
    }
}
