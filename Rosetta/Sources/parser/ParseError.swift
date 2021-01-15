//
//  ParseError.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// All Parsing errors should implement this protocol
public protocol ParseError: Error, CustomStringConvertible {
    var message: String { get }
    var line: Int? { get }
    var column: Int? { get }
}

public extension ParseError {
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
public struct AllParserError: ParseError {
    public var message: String
    public var line: Int?
    public var column: Int?
    var errors: [ParseError]

    public init(withErrors errors: [ParseError]) {
        self.message = "Parsing Error:\n"
        self.errors = errors
    }

    /// Returns the description of all accumulated errors
    public var description: String {
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
public struct MissingExpected: ParseError {
    public var message: String
    public var line: Int?
    public var column: Int?

    public init(type: Token.Kind, line: Int? = nil, column: Int? = nil) {
        self.message = "Expected token \"\(type)\""
        self.line = line
        self.column = column
    }
}
