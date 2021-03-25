//
//  MonkeyLexer.swift
//  rosetta
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation
import Rosetta

/// Convinience so we can throw `String` as Errors
extension String: Error { }
/// Convinience so we can throw `Character` as Errors
extension Character: Error { }

public struct MonkeyLexer: Lexer {
    public static let scapeCharacters: [Character: Character] = [
        "n": "\n",
        "t": "\t",
        "\"": "\"",
        "\\": "\\"
    ]

    public var readingChars: (current: Character?, next: Character?)?

    public let filePath: URL?
    public var input: String

    public var streamReader: StreamReader?

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
        self.streamReader = StreamReader(url: filePath)

        self.readLine()
        self.readChar()
    }

    public init(withString input: String) {
        self.input = input
        self.filePath = nil

        self.readLine()
        self.readChar()
    }

    public mutating func readLine() {
        if filePath != nil {
            self.readFileLine()
        } else {
            self.readStringLine()
        }
    }

    // swiftlint:disable function_body_length
    public mutating func nextToken() -> Token {
        let file = filePath?.absoluteString.replacingOccurrences(of: "file://", with: "")
        // TODO: Reduce body size
        guard !self.input.isEmpty || self.streamReader != nil else {
            return Token(
                type: .eof,
                literal: "",
                file: file,
                line: self.currentLineNumber,
                column: self.currentColumn
            )
        }

        self.skipWhitespace()

        guard let char = self.readingChars?.current else {
            return Token(
                type: .eof,
                literal: "",
                file: file,
                line: self.currentLineNumber,
                column: self.currentColumn
            )
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
            if next == "/" {
                let comment = self.readComment()
                token = Token(
                    type: .comment,
                    literal: comment
                )
            } else if next == "*" {
                let comment = self.readMultilineComment()
                token = Token(
                    type: .comment,
                    literal: comment
                )
            } else {
                token = Token(type: .slash, literal: String(char))
            }
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
        case ":":
            token = Token(type: .colon, literal: String(char))
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
        case "[":
            token = Token(type: .lbracket, literal: String(char))
        case "]":
            token = Token(type: .rbracket, literal: String(char))
        case "\"":
            self.readChar()
            do {
                let literal = try readString()
                token = Token(type: .string, literal: literal)
            } catch let error as Character {
                token = Token(type: .ilegal, literal: String(error))
            } catch let error as String {
                token = Token(type: .ilegal, literal: error)
            } catch {
                token = Token(type: .ilegal, literal: String(char))
            }
        default:
            if char.isIdentifierLetter {
                let literal = self.readIdentifier()
                let type: Token.Kind = Token.Kind.keywords.contains(literal) ? literal : .identifier
                return Token(type: type, literal: literal, file: file, line: startLine, column: startColumn)
            } else if char.isNumber {
                let literal = self.readNumber()
                return Token(type: .int, literal: literal, file: file, line: startLine, column: startColumn)
            }
            token = Token(type: .ilegal, literal: String(char))
        }

        self.readChar()
        token.line = startLine
        token.column = startColumn
        token.file = file

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

    mutating func readComment() -> String {
        // Read both "/"
        self.readChar()
        self.readChar()

        // Keep slashes as part of the literal
        var output = "//"
        repeat {
            guard let current = self.readingChars?.current else {
                break
            }

            output += String(current)
            guard self.readingChars?.next != "\n" else {
                return output
            }

            self.readChar()
        } while self.readingChars?.current != nil && self.readingChars?.current != "\""

        return output
    }

    mutating func readMultilineComment() -> String {
        // Keep comment start as part of the literal
        var output = "/*"
        // Read "/"
        self.readChar()

        // If the first line of the comment is empty
        // make sure we keep the line break in the comment
        if self.readingChars?.next == "\n" {
            output += "\n"
        }

        // Read *
        self.readChar()
        repeat {
            guard let current = self.readingChars?.current else {
                break
            }

            if current == "*" && self.readingChars?.next == "/" {
                self.readChar()
                break
            }

            output += String(current)
            if self.readingChars?.next == "\n" {
                output += "\n"
            }
            self.readChar()
        } while self.readingChars?.current != nil && self.readingChars?.current != "\""

        return output + "*/"
    }

    mutating func readString() throws -> String {
        guard let first = self.readingChars?.current, first != "\"" else {
            return ""
        }

        var output = ""
        repeat {
            guard let current = self.readingChars?.current else {
                break
            }

            guard current != "\n" && self.readingChars?.next != "\n" else {
                throw "\n"
            }

            if current == "\\" {
                guard let next = self.readingChars?.next else { break }

                guard let scaped = MonkeyLexer.scapeCharacters[next] else {
                    throw next
                }

                output += String(scaped)
                self.readChar()
                guard self.readingChars?.next != "\n" else {
                    throw "\n"
                }
                self.readChar()
                continue
            }

            output += String(current)
            self.readChar()
        } while self.readingChars?.current != nil && self.readingChars?.current != "\""

        return output
    }
}

extension MonkeyLexer: StringLexer {
}

extension MonkeyLexer: FileLexer {
}
