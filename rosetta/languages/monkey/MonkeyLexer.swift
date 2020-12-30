//
//  MonkeyLexer.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation

struct MonkeyLexer: Lexer, StringLexer, FileLexer {
    let filePath: URL?
    let input: String?
    
    var currentLineNumber = 0
    var currentColumn = 0
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
    
    mutating func nextToken() -> Token {
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
    
    func readLine() {
        // TODO:
    }
    
    internal mutating func skipWhitespace() {
        guard let input = self.input else {
            return
        }
        
        self.skip(fromInput: input) { $0.isWhitespace }
    }
    
    mutating func readIdentifier() -> String {
        guard let input = self.input else {
            return ""
        }
        
        return self.read(fromInput: input) { $0.isIdentifierLetter }
    }
    
    mutating func readNumber() -> String {
        guard let input = self.input else {
            return ""
        }
        // TODO: Support floating points
        return self.read(fromInput: input) { $0.isNumber }
    }
}
