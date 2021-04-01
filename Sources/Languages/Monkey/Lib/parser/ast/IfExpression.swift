//
//  IfExpression.swift
//  Hermes
//
//  Created by Franklin Cruz on 04-01-21.
//

import Foundation
import Hermes

/// Represent expressions in the form of:
/// `if (<condition>) <consequence> else <alternative>`
/// where consequence and alternatives are `BlockStatements`
struct IfExpression: Expression {
    var token: Token
    var condition: Expression
    var consequence: BlockStatement
    var alternative: BlockStatement?

    var description: String {
        var output = "if (\(condition)) \(consequence)"

        if let alternative = self.alternative {
            output += " else \(alternative)"
        }

        return output
    }
}
