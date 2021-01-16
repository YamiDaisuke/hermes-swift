//
//  PrefixExpression.swift
//  rosetta
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation
import Rosetta

/// Throw this error if there is no known way to parse a given `Token`
/// as a prefix operator
struct MissingPrefixFunc: ParseError {
    var message: String
    var line: Int?
    var column: Int?

    init(token: Token) {
        self.message = "Missing prefix parse function for \(token.literal)"
        self.line = token.line
        self.column = token.column
    }
}

/// Represent expressions in the form of:
/// `<operator><expression>`
struct PrefixExpression: Expression {
    var token: Token
    var operatorSymbol: String
    var rhs: Expression

    var description: String {
        "(\(operatorSymbol)\(rhs))"
    }
}