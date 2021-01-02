//
//  ParseError.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// All Parsing errors should implement this protocol
protocol ParseError: Error, CustomStringConvertible {
    var message: String { get }
    var line: Int? { get }
    var column: Int? { get }
}

extension ParseError {
    var description: String {
        var output = self.message

        if let line = line, let col = column {
            output += " at Line: \(line), Column: \(col)"
        }

        return output
    }
}

/// Helper error struct, so we can accumulate all errors
/// found while parsing the program instead of just stoping
/// the loop at first error
struct AllParserError: ParseError {
    var message: String
    var line: Int?
    var column: Int?
    var errors: [ParseError]

    init(withErrors errors: [ParseError]) {
        self.message = "Parsing Error:\n"
        self.errors = errors
    }

    /// Returns the description of all accumulated errors 
    var description: String {
        var output = self.message
        for error in errors {
            output += "\(error)\n"
        }
        return output
    }
}

/// Throw this error when the next token is not what the
/// parser expects. E.G.: `let a 5;` should throw this
/// error because it misses an equals sign between `a` and `5`
struct MissingExpected: ParseError {
    var message: String
    var line: Int?
    var column: Int?

    init(type: Token.Kind, line: Int?, column: Int?) {
        self.message = "Expected token \(type)"
        self.line = line
        self.column = column
    }
}
