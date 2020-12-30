//
//  Lexer.swift
//  rossetta
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation

/// This protocol describes the interface for any language
/// lexer
protocol Lexer {
    var currentLineNumber: Int { get set }
    var currentColumn: Int { get set }

    
    /// Should read this `Lexer` input source and return the next parsed
    /// `Token` instance
    /// - Returns: A valid `Token` instance for the current language
    mutating func nextToken() -> Token
}


/// A Lexer that uses a file as the input for processing
protocol FileLexer: Lexer {
    var filePath: URL? { get }
    
    /// Reads the next line in the file and moves the
    /// `currentLineNumber` and `currentColumn`
    /// pointers of the `Lexer` to the right value
    mutating func readLine()
}

/// A Lexer that uses a `String` as input for processing
protocol StringLexer: Lexer {
    var input: String? { get set }
}


extension Lexer {
    
    /// Skips characters in the input source while a condition is met, starting from
    ///
    /// `Lexer.currentColumn`
    /// - Parameters:
    ///   - input: Input source to check for `predicate`
    ///   - predicate: An expression that indicates wich characters to skip
    mutating func skip(fromInput input: String, while predicate: (Character) -> Bool) {
        // TODO: Handle line breaks
        let startIndex = self.currentColumn
        var steps = 0
        for char in String(input[startIndex...]) {
            if predicate(char) {
                steps += 1
            } else {
                break
            }
        }
        
        self.currentColumn += steps
    }
    
    
    /// Returns a sub-string from the input starting from `Lexer.currentColumn`
    /// until the first character that not met the condition
    /// - Parameters:
    ///   - input: The input to take the sub-string from
    ///   - predicate: An expression that indicates wich characters to take
    /// - Returns: A sub-string that mets the condition from the `while` predicate 
    mutating func read(fromInput input: String, while predicate: (Character) -> Bool) -> String {
        // TODO: Handle line breaks
        let startIndex = self.currentColumn
        var steps = 0
        for char in input[self.currentColumn...] {
            if predicate(char) {
                steps += 1
            } else {
                break
            }
        }
        
        self.currentColumn += steps
        return String(input[startIndex..<self.currentColumn])
    }
}
