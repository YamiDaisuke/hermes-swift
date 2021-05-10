//
//  MonkeyLexer.swift
//  Hermes
//
//  Created by Franklin Cruz on 30-12-20.
//

import Foundation
import Hermes

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

    public mutating func nextToken() -> Token {
        let file = filePath?.absoluteString.replacingOccurrences(of: "file://", with: "")
        var token = Token(
            type: .eof,
            literal: "",
            file: file,
            line: self.currentLineNumber,
            column: self.currentColumn
        )

        guard !self.input.isEmpty || self.streamReader != nil else {
            return token
        }

        self.skipWhitespace()

        guard let char = self.readingChars?.current else {
            return token
        }

        var next = ""
        if let nextChar = self.readingChars?.next {
            next = String(nextChar)
        }

        let startLine = self.currentLineNumber
        let startColumn = self.currentColumn

        switch char {
        case "+", "-", "*", ";", ":", "(", ")", ",", "{", "}", "[", "]":
            // For all single character tokens the kind constant matches the character
            token = Token(type: Token.Kind(char), literal: String(char))
        case "=", "!", "<", ">":
            if next == "=" {
                // For ==, !=, <=, >= tokens the kind constant matches the characters
                token = Token(type: Token.Kind(String(char) + next), literal: String(char) + next)
                self.readChar()
            } else {
                // For all single character tokens the kind constant matches the character
                token = Token(type: Token.Kind(char), literal: String(char))
            }
        case "/":
            if let comment = self.tokenizeComments(nextCharacter: next) {
                token = comment
            } else {
                token = Token(type: .slash, literal: String(char))
            }
        case "\"":
            token = self.tokenizeString(char)
        default:
            if char.isValidIdentifierStart {
                let literal = self.readIdentifier()
                let type: Token.Kind = Token.Kind.keywords.contains(literal) ? literal : .identifier
                return Token(type: type, literal: literal, file: file, line: startLine, column: startColumn)
            } else if char.isNumber {
                let literal = self.readNumber()

                if self.readingChars?.current == "." {
                    guard self.readingChars?.next?.isNumber ?? false else {
                        if let ilegalLiteral = self.readingChars?.next {
                            token = Token(type: .ilegal, literal: String(ilegalLiteral))
                        } else {
                            token = Token(type: .ilegal, literal: "")
                        }
                        break
                    }
                    // Read floats
                    self.readChar()
                    let decimalPart = self.readNumber()
                    let number = "\(literal).\(decimalPart)"
                    return Token(type: .float, literal: number, file: file, line: startLine, column: startColumn)
                }

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

    /// Tokenizes single line or multiline comments if the pattern does not match a valid comment
    /// it returns a `nil` `Token`
    mutating func tokenizeComments(nextCharacter next: String) -> Token? {
        var token: Token?
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
        }

        return token
    }


    /// Tokenizes string literals
    /// - Parameter initial: The current reading char
    /// - Returns: The string `Token` or `ilegal` if the pattern is invalid
    mutating func tokenizeString(_ initial: Character) -> Token {
        var token: Token
        self.readChar()
        do {
            let literal = try readString()
            token = Token(type: .string, literal: literal)
        } catch let error as Character {
            token = Token(type: .ilegal, literal: String(error))
        } catch let error as String {
            token = Token(type: .ilegal, literal: error)
        } catch {
            token = Token(type: .ilegal, literal: String(initial))
        }

        return token
    }

    mutating func skipWhitespace() {
        self.skip { $0.isWhitespace }
    }

    mutating func readIdentifier() -> String {
        return self.read { $0.isIdentifierCharacter }
    }

    mutating func readNumber() -> String {
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
