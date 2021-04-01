//
//  InfixExpression.swift
//  rosetta
//
//  Created by Franklin Cruz on 03-01-21.
//

import Foundation
import Hermes

/// Represent expressions in the form of:
/// `<expression> <operator> <expression>`
struct InfixExpression: Expression {
    var token: Token
    var lhs: Expression
    var operatorSymbol: String
    var rhs: Expression

    var description: String {
        "(\(lhs) \(operatorSymbol) \(rhs))"
    }
}
