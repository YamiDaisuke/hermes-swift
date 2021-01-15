//
//  IntegerLiteral.swift
//  rosetta
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation
import Rosetta

/// Throw this error when an invalid integer
/// literal is found in the input script
struct InvalidIntegerLiteral: ParseError {
    var message: String
    var line: Int?
    var column: Int?

    init(literal: String, line: Int? = nil, column: Int? = nil) {
        self.message = "Invalid Integer Literal \(literal)"
        self.line = line
        self.column = column
    }
}

/// This `Node` represents an integer literal in Monkey language
struct IntegerLiteral: Expression {
    var token: Token
    // Should we use a fixed bytes integer instead?
    var value: Int

    init(token: Token) throws {
        self.token = token
        guard let intValue = Int(token.literal) else {
            throw InvalidIntegerLiteral(literal: token.literal, line: token.line, column: token.column)
        }
        self.value = intValue
    }

    var description: String {
        value.description
    }
}
