//
//  IntegerLiteral.swift
//  Hermes
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation
import Hermes

/// Throw this error when an invalid integer
/// literal is found in the input script
struct InvalidIntegerLiteral: ParseError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(literal: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Invalid Integer Literal \(literal)"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// This `Node` represents an integer literal in Monkey language
struct IntegerLiteral: Expression {
    var token: Token
    // Should we use a fixed bytes integer instead?
    var value: Int32

    init(token: Token) throws {
        self.token = token
        guard let intValue = Int32(token.literal) else {
            throw InvalidIntegerLiteral(literal: token.literal, line: token.line, column: token.column)
        }
        self.value = intValue
    }

    var description: String {
        value.description
    }
}
