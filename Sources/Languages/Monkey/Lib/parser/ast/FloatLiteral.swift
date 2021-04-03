//
//  FloatLiteral.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 03-04-21.
//

import Foundation
import Hermes

/// Throw this error when an invalid float
/// literal is found in the input script
struct InvalidFloatLiteral: ParseError {
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

/// This `Node` represents an float literal in Monkey language
struct FloatLiteral: Expression {
    var token: Token
    var value: Float64

    init(token: Token) throws {
        self.token = token
        guard let floatValue = Float64(token.literal) else {
            throw InvalidIntegerLiteral(literal: token.literal, line: token.line, column: token.column)
        }
        self.value = floatValue
    }

    var description: String {
        value.description
    }
}
