//
//  Lexer.swift
//  rossetta
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation

/// This protocol describes the interface for any language
/// lexer
public protocol Lexer {
    var currentLineNumber: Int { get set }
    /// The position of the current `Character` in the current line
    var currentColumn: Int { get set }

    /// The line we are currently tokenizing
    var currentLine: String { get set }
    /// The `Character` we are currently tokenizing and a peek of
    /// the next one
    var readingChars: (current: Character?, next: Character?)? { get set }

    /// How many `Characters` we have actually read
    var readCharacterCount: Int { get set }

    /// Should read this `Lexer` input source and return the next parsed
    /// `Token` instance
    /// - Returns: A valid `Token` instance for the current language
    mutating func nextToken() -> Token

    /// Reads the next line in the file and moves the
    /// `currentLineNumber` and `currentColumn`
    /// pointers of the `Lexer` to the right value
    mutating func readLine()
}

/// A Lexer that uses a file as the input for processing
public protocol FileLexer: Lexer {
    var filePath: URL? { get }
}

/// A Lexer that uses a `String` as input for processing
public protocol StringLexer: Lexer {
    var input: String { get set }
}

public extension Lexer {
    /// Reads the next `Character` from the input and updates the column, line, and
    /// character pointers accordingly
    ///
    /// - Returns: The `Character` at the new position and the `Character` as a `Tuple`
    @discardableResult
    mutating func readChar() -> (current: Character?, next: Character?)? {
        self.currentColumn += 1
        guard self.currentColumn < currentLine.count else {
            // TODO: Should we set currentColum to some special value
            self.readingChars = (current: nil, next: nil)
            return self.readingChars
        }

        let char = currentLine[self.currentColumn]
        if char.isNewline {
            self.readLine()
            return self.readChar()
        }

        var next: Character?
        if (self.currentColumn + 1) < currentLine.count {
            let nextIndex = currentLine.index(currentLine.startIndex, offsetBy: self.currentColumn + 1)
            next = currentLine[nextIndex]
        }

        self.readingChars = (current: char, next: next)
        return self.readingChars
    }

    /// Skips characters in the input source while a condition is met, starting from
    /// the `self.currentColumn`. This function might move the current columm and line
    /// pointer accordingly to the number of character skiped
    ///
    /// `Lexer.currentColumn`
    /// - Parameters:
    ///   - predicate: An expression that indicates wich characters to skip
    mutating func skip(while predicate: (Character) -> Bool) {
        // If we haven't start reading the current line let's start
        if self.currentColumn == -1 {
            self.readChar()
        }

        guard let first = self.readingChars?.current, predicate(first) else {
            return
        }

        repeat {
            guard self.readingChars?.current != nil else {
                break
            }
            self.readChar()
            // swiftlint:disable:next force_unwrapping
        } while self.readingChars?.current != nil && predicate(self.readingChars!.current!)
    }

    /// Returns a sub-string from the input starting from `self.currentColumn`
    /// until the first character that not met the condition. This function might move the
    /// current columm and line pointer accordingly to the number of character read
    ///
    /// - Parameters:
    ///   - input: The input to take the sub-string from
    ///   - predicate: A predicate function to check if the next character should be taken
    ///                it will recieve the current read `Character`
    /// - Returns: A sub-string that mets the condition from the `while` predicate
    mutating func read(while predicate: (Character) -> Bool) -> String {
        guard let first = self.readingChars?.current, predicate(first) else {
            return ""
        }

        var output = ""
        repeat {
            guard let current = self.readingChars?.current else {
                break
            }
            output += String(current)
            self.readChar()
            // swiftlint:disable:next force_unwrapping
        } while self.readingChars?.current != nil && predicate(self.readingChars!.current!)

        return output
    }
}

public extension StringLexer {
    /// Moves column, line index and line pointers to the next line in the original
    /// `self.input`
    mutating func readLine() {
        self.currentLineNumber += 1
        self.currentColumn = -1

        guard !self.input.isEmpty else {
            return
        }

        let start = self.readCharacterCount
        var count = 0
        for char in input[start...] {
            if !char.isNewline {
                count += 1
            } else {
                count += 1
                break
            }
        }

        self.readCharacterCount += count
        self.currentLine = String(input[start..<(start + count)])
    }
}
