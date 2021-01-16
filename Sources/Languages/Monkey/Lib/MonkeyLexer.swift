//
//  MonkeyLexer.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation
import Rosetta

public struct MonkeyLexer: Lexer, StringLexer, FileLexer {
    public var readingChars: (current: Character?, next: Character?)?

    public let filePath: URL?
    public var input: String

    public var currentLineNumber = 0
    public var currentColumn = 0

    public var readCharacterCount = 0

    public var currentLine = ""

    public init() {
        self.filePath = nil
        self.input = ""
    }

    public init(withFilePath filePath: URL) {
        self.filePath = filePath
        self.input = ""
    }

    public init(withString input: String) {
        self.input = input
        self.filePath = nil

        self.readLine()
        self.readChar()
    }

    // swiftlint:disable function_body_length
    public mutating func nextToken() -> Token {
        // TODO: Reduce body size
        guard !self.input.isEmpty else {
            return Token(type: .eof, literal: "", line: self.currentLineNumber, column: self.currentColumn)
        }

        self.skipWhitespace()

        guard let char = self.readingChars?.current else {
            return Token(type: .eof, literal: "", line: self.currentLineNumber, column: self.currentColumn)
        }

        var next = ""
        if let nextChar = self.readingChars?.next {
            next = String(nextChar)
        }

        let startLine = self.currentLineNumber
        let startColumn = self.currentColumn
        var token = Token(type: .eof, literal: "")
        switch char {
        case "=":
            if next == "=" {
                token = Token(type: .equals, literal: String(char) + next)
                self.readChar()
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
                self.readChar()
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
                self.readChar()
            } else {
                token = Token(type: .lt, literal: String(char))
            }
        case ">":
            if next == "=" {
                token = Token(type: .gte, literal: String(char) + next)
                self.readChar()
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
                return Token(type: type, literal: literal, line: startLine, column: startColumn)
            } else if char.isNumber {
                let literal = self.readNumber()
                return Token(type: .int, literal: literal, line: startLine, column: startColumn)
            }
            token = Token(type: .ilegal, literal: String(char))
        }

        self.readChar()
        token.line = startLine
        token.column = startColumn
        return token
    }

    mutating func skipWhitespace() {
        self.skip { $0.isWhitespace }
    }

    mutating func readIdentifier() -> String {
        return self.read { $0.isIdentifierLetter }
    }

    mutating func readNumber() -> String {
        // TODO: Support floating points
        return self.read { $0.isNumber }
    }
}